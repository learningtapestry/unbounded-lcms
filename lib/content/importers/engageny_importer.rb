require 'date'
require 'set'

module Content
  module Importers
    class EngagenyImporter
      include Content::Models

      ELA_CURRICULUM_NIDS = [
        26661, 27791, 27786, 27781, 8421, 25011, 25021, 25096, 25131, 25141, 26211, 26266, 26491, 27801
      ]

      MATH_CURRICULUM_NIDS = [
        28461, 24991, 26481, 26486, 25601, 26496, 26501, 25836, 26216, 26271, 26276, 26281, 27041, 27046
      ]

      class EngagenyNode < ActiveRecord::Base
        # EngageNY columns clash with ActiveRecord defaults
        require 'safe_attributes/base'
        include SafeAttributes::Base

        self.table_name = 'node'
        self.inheritance_column = :_type_disabled
        self.primary_key = 'nid'

        establish_connection(:engageny)

        def extract_by_sql(callable, sql)
          EngagenyNode.find_by_sql([sql, nid]).map(&callable)
        end
      end

      class << self
        include Content::Models

        def find_lobject_by_nid(nid)
          Lobject.find_by_sql([%{
            select l.*
            from lobjects l
            inner join lobject_documents ld on ld.lobject_id = l.id
            inner join documents d on d.id = ld.document_id
            inner join engageny_documents ed on ed.source_document_id = d.source_document_id
            where ed.nid = ?
            limit 1
          }, nid]).first
        end

        def create_lob_by_title(title)
          unless lob = Lobject.includes(:lobject_titles).where(lobject_titles: { title: title }).first
            lob = Lobject.create(hidden: true)
            lob.lobject_titles << LobjectTitle.new(title: title)
          end
          lob
        end

        def import_node(eny_node)
          return if EngagenyDocument.where(nid: eny_node.nid).size > 0

          eny_doc = EngagenyDocument.new

          eny_doc.nid = eny_node.nid

          eny_doc.title = eny_node.title

          eny_doc.active = (eny_node.status.to_i == 1)

          eny_doc.description = EngagenyNode.find_by_sql([%{
            select body_value from field_data_body where entity_id = ?
          }, eny_node.nid]).map(&:body_value).first

          eny_doc.doc_created_at = DateTime.strptime(eny_node.created.to_s, '%s')

          eny_doc.grades = EngagenyNode.find_by_sql([%{
            select taxonomy_term_data.name 
            from taxonomy_index
            inner join taxonomy_term_data on taxonomy_term_data.tid = taxonomy_index.tid
            inner join taxonomy_vocabulary on taxonomy_vocabulary.vid = taxonomy_term_data.vid
            where nid = ? and taxonomy_vocabulary.name = 'Grades'
          }, eny_node.nid]).map(&:name)

          eny_doc.subjects = EngagenyNode.find_by_sql([%{
            select taxonomy_term_data.name 
            from taxonomy_index 
            inner join taxonomy_term_data on taxonomy_term_data.tid = taxonomy_index.tid
            inner join taxonomy_vocabulary on taxonomy_vocabulary.vid = taxonomy_term_data.vid
            where nid = ? and taxonomy_vocabulary.name = 'Subject'
          }, eny_node.nid]).map(&:name)

          eny_doc.topics = EngagenyNode.find_by_sql([%{
            select taxonomy_term_data.name
            from taxonomy_index 
            inner join taxonomy_term_data on taxonomy_term_data.tid = taxonomy_index.tid
            inner join taxonomy_vocabulary on taxonomy_vocabulary.vid = taxonomy_term_data.vid
            where nid = ? and taxonomy_vocabulary.name = 'Topic'
          }, eny_node.nid]).map(&:name)

          eny_doc.resource_types = EngagenyNode.find_by_sql([%{
            select taxonomy_term_data.name
            from taxonomy_index 
            inner join taxonomy_term_data on taxonomy_term_data.tid = taxonomy_index.tid
            inner join taxonomy_vocabulary on taxonomy_vocabulary.vid = taxonomy_term_data.vid
            where nid = ? and taxonomy_vocabulary.name = 'Resource Type'
          }, eny_node.nid]).map(&:name)

          standards = Hash.new { |h, k| h[k] = [] }
          EngagenyNode.find_by_sql([%{
            select taxonomy_vocabulary.name as vocabulary_name, taxonomy_term_data.name 
            from taxonomy_index 
            inner join taxonomy_term_data on taxonomy_term_data.tid = taxonomy_index.tid 
            inner join taxonomy_vocabulary on taxonomy_vocabulary.vid = taxonomy_term_data.vid 
            where nid = ? and taxonomy_vocabulary.name like 'CCLS%'
          }, eny_node.nid])
          .each{ |r| standards[r.vocabulary_name.gsub('CCLS - ', '').gsub('CCLS', 'ELA')] << r.name }

          eny_doc.standards = standards

          eny_doc.downloadable_resources = EngagenyNode.find_by_sql([%{
            SELECT field_downloadable_resources_fid, file_managed.filename, file_managed.uri, filemime, field_title_value, filesize
            FROM field_data_field_downloadable_resources
            INNER JOIN file_managed on file_managed.fid = field_data_field_downloadable_resources.field_downloadable_resources_fid
            INNER JOIN field_data_field_title on field_data_field_title.entity_id = file_managed.fid and field_data_field_title.entity_type='file'
            where field_data_field_downloadable_resources.entity_id = ? and field_data_field_downloadable_resources.entity_type='node'
            and field_downloadable_resources_display=1
          }, eny_node.nid])
          .map { |r| r.as_json(except: [:nid]) }

          aliases = EngagenyNode.find_by_sql([%{
            select alias from url_alias where source = ?
          }, "node/#{eny_node.nid}"])

          if aliases.size > 0
            eny_doc.url = "https://www.engageny.org/#{aliases.first.alias}" 
          end

          eny_doc.initialize_source_document
          eny_doc.save!
        end

        def import_non_canonical_urls
          redirects = EngagenyNode.find_by_sql(%{
            select source, redirect from redirect where redirect like 'node/%'
          })

          redirects.each do |r|
            nid = r['redirect'].sub('node/', '').to_i
            if lobj = find_lobject_by_nid(nid)
              canonical_url = lobj.url.canonical
              Url.find_or_create_by(
                url: "https://www.engageny.org/#{r['source']}",
                parent_id: canonical_url.id
              )
            end
          end
        end

        def import_all_nodes
          EngagenyNode.order(nid: :asc).find_each do |eny_node|
            import_node(eny_node)
          end
        end

        def build_collections
          menu_links = EngagenyNode.find_by_sql(%{
            select * from menu_links ml inner join book b on ml.mlid = b.mlid where ml.p1 in (
              select b.mlid
              from book b
              inner join node n on b.nid = n.nid
              where b.nid = b.bid
            )
          })

          collection_hash = { items: {} }

          menu_links.each do |ml_node|
            current_hash = collection_hash

            (1..7).each do |i|
              parent_id = ml_node["p#{i}"]
              break if parent_id == 0

              unless current_hash[:items].has_key?(parent_id)
                current_hash[:items][parent_id] = { items: {} }
              end

              current_hash = current_hash[:items][parent_id]

              if parent_id == ml_node['mlid']
                current_hash[:title] = ml_node['link_title']
                current_hash[:nid] = ml_node['nid']
                current_hash[:weight] = ml_node['weight']
              end
            end
          end

          collection_hash
        end

        def create_collection_for_nids(title, nids)
          root_lob = create_lob_by_title(title)

          return if LobjectCollection.where(lobject_id: root_lob.id).size > 0

          col = LobjectCollection.create(lobject_id: root_lob.id)

          nids.each_with_index do |nid, i|
            LobjectChild.create(
              parent: root_lob, 
              collection: col, 
              child: find_lobject_by_nid(nid),
              position: i
            )
          end
        end

        def import_collection(collection_hash, collection = nil)
          curriculum_map_type = Content::Models::LobjectCollectionType.find_or_create_by!(name: 'Curriculum Map')

          if collection_hash[:items].keys.size > 0
            lobject = find_lobject_by_nid(collection_hash[:nid])

            return if lobject.lobject_collections.size > 0

            unless collection
              new_params = {lobject: lobject}
              if (ELA_CURRICULUM_NIDS.include?(collection_hash[:nid]) \
                  || MATH_CURRICULUM_NIDS.include?(collection_hash[:nid]))
                new_params[:lobject_collection_type] = curriculum_map_type
              end
              collection = LobjectCollection.new(new_params)
            end

            i = 0
            collection_hash[:items].sort_by { |k,v| v[:weight] }.each do |mlid, child_hash|
              i += 1
              child_lob = find_lobject_by_nid(child_hash[:nid])
              LobjectChild.create(
                parent: lobject,
                child: child_lob,
                lobject_collection: collection,
                position: i
              )

              import_collection(child_hash, collection)
            end
          end
        end

        def import_related_lobjects
          related = EngagenyNode.find_by_sql(%{
            select delta, entity_id as nid, field_related_resources_target_id as related_nid 
            from field_data_field_related_resources
          })

          related_map = {}

          related.each do |rel|
            related_map[rel['nid']] ||= []
            related_map[rel['nid']] << { position: rel['delta'], nid: rel['related_nid'] }
            related_map[rel['nid']].sort_by! { |r| r[:position] }
          end

          related_map.each do |nid, rels|
            lob = find_lobject_by_nid(nid)
            
            return if lob.lobject_related_lobjects.size > 0

            rels.each_with_index do |rel, i|
              LobjectRelatedLobject.create(
                lobject: lob,
                related_lobject: find_lobject_by_nid(rel[:nid]),
                position: i
              )
            end
          end
        end

        def import_all_collections_and_related
          build_collections[:items].each { |k, coll| import_collection(coll) }

          create_collection_for_nids(
            'ELA Curriculum Map', ELA_CURRICULUM_NIDS
          )

          create_collection_for_nids(
            'Math Curriculum Map', MATH_CURRICULUM_NIDS
          )

          import_related_lobjects
        end

        def update_engageny_lobjects
          unbounded_org = Organization.find_or_create_by!(name: 'UnboundEd')
          Lobject.connection.execute(%{
            update lobjects
            set organization_id = #{unbounded_org.id}
            where id in (
              select distinct l.id
              from lobjects l
              inner join lobject_documents ld on ld.lobject_id = l.id
              inner join documents d on d.id = ld.document_id
              inner join source_documents sd on sd.id = d.source_document_id
              where sd.source_type = #{SourceDocument.source_types[:engageny]}
            )
          })
        end

        def import_additional_lobjects
          LobjectDescription.where("description LIKE '%Additional Materials%'").includes(:lobject).each do |lobject_description|
            lobject   = lobject_description.lobject
            presenter = Unbounded::LobjectPresenter.new(lobject)

            doc = presenter.send(:html_description)
            par = doc.xpath('//p[strong/text()="Additional Materials:"]').first
            ul  = par.try(:next_element)

            if ul && ul.name == 'ul'
              ul.css('li a').each_with_index do |link, index|
                create_additional_lobject(lobject, link[:href], index + 1)
              end
              ul.remove
            else
              doc.xpath('//p[preceding-sibling::p[strong/text()="Additional Materials:"]]').each_with_index do |par, index|
                create_additional_lobject(lobject, par.css('a').first[:href], index + 1)
                par.remove
              end
            end

            par.remove
            doc.xpath("//text()").each { |text| text.content = text.content.gsub(/(\s*\n)+/, '') }
            lobject_description.update_column(:description, doc.to_html)
          end
        end

        def create_additional_lobject(lobject, href, position)
          raise "Not rewritten URL found: #{href}" unless href =~ /resources\/\d+/

          additional_lobject_id = href[/\d+/]
          lobject.lobject_additional_lobjects.create_with(position: position).find_or_create_by!(additional_lobject_id: additional_lobject_id)
        end

        def fix_curriculum_maps
          Lobject.transaction do
            LobjectCollection.curriculum_maps.each do |curriculum_map|
              mods = curriculum_map.lobject.lobject_children
              empty_mods = mods.select { |mod| mod.child.lobject_children.empty?  }
              empty_unit_mods = mods.select do |mod|
                !mod.child.lobject_children.empty? && mod.child.lobject_children.all? do |unit| 
                  unit.child.lobject_children.empty?
                end
              end

              has_empty_mods = empty_mods.size > 0
              doesnt_have_empty_units = empty_unit_mods.empty?

              if has_empty_mods && doesnt_have_empty_units
                parent_mod = Lobject.create!(organization: Organization.unbounded)
                grade = curriculum_map.lobject.grades.first.grade.capitalize
                subject = curriculum_map.lobject.curriculum_subject.to_s.capitalize
                parent_mod.lobject_titles << LobjectTitle.new(title: "#{grade} #{subject} Developing Core Proficiencies Curriculum")
                mod_node = LobjectChild.create!(
                  parent: empty_mods.first.parent,
                  child: parent_mod,
                  lobject_collection_id: curriculum_map.id,
                  position: 0
                )

                empty_mods.each_with_index do |empty_mod, i|
                  empty_mod.parent = parent_mod
                  empty_mod.position = i + 1
                  empty_mod.save!
                end

                mod_node.position = mod_node.parent.lobject_children.size
                mod_node.save!
              end

              curriculum_map.generate_slugs
            end
          end
        end

        def create_additional_modules
          create_module(
            Lobject.by_title('Grade 9 English Language Arts').first,
            'Grade 9 ELA Writing Module',
            {
              'Grade 9 ELA Writing Module, Unit 1 - Keep on Reading' => 20,
              'Grade 9 ELA Writing Module, Unit 2 - Informative Writing' => 20,
              'Grade 9 ELA Writing Module, Unit 3 - Narrative Writing' => 19
            }
          )

          create_units(
            Lobject.by_title('Grade 11 ELA Module 3').first,
            {
              'Grade 11 ELA Module 3, Unit 1' => 11,
              'Grade 11 ELA Module 3, Unit 2' => 15,
              'Grade 11 ELA Module 3, Unit 3' => 12
            }
          )

          create_units(
            Lobject.by_title('Grade 11 ELA Module 4').first,
            {
              'Grade 11 ELA Module 4, Unit 1' => 16,
              'Grade 11 ELA Module 4, Unit 2' => 22
            }
          )

          create_units(
            Lobject.by_title('Grade 12 ELA Module 2').first,
            {
              'Grade 12 ELA Module 2, Unit 1' => 16,
              'Grade 12 ELA Module 2, Unit 2' => 22
            }
          )

          create_units(
            Lobject.by_title('Grade 12 ELA Module 3').first,
            {
              'Grade 12 ELA Module 3, Unit 1' => 27,
              'Grade 12 ELA Module 3, Unit 2' => 11
            }
          )
        end

        def create_writing_module
          module_title = 'Grade 9 ELA Writing Module'

          Lobject.transaction do
            root_lobject = LobjectBuilder.new
              .set_organization(Organization.unbounded)
              .add_title(module_title)
              .save!

            grade_9_lobject = Lobject.by_title('Grade 9 English Language Arts').first
            grade_9_collection = grade_9_lobject.curriculum_map_collection
            grade_9_collection.add_child(root_lobject)

            module_structure = {
              "#{module_title}, Unit 1 - Keep on Reading" => 20,
              "#{module_title}, Unit 2 - Informative Writing" => 20,
              "#{module_title}, Unit 3 - Narrative Writing" => 19
            }

            module_structure.each do |unit_title, lesson_count|
              unit = LobjectBuilder.new
                .set_organization(Organization.unbounded)
                .add_title(unit_title)
                .save!

              puts "#{unit.id} - #{unit.title}"

              grade_9_collection.add_child(unit, parent: root_lobject)

              lesson_count.times do |i|
                lesson_no = i+1

                lesson = LobjectBuilder.new
                  .set_organization(Organization.unbounded)
                  .add_title("#{unit_title}, Lesson #{lesson_no}")
                  .save!

                  puts "#{lesson.id} - #{lesson.title}"

                grade_9_collection.add_child(lesson, parent: unit)
              end
            end

            grade_9_collection.save!
          end
        end

        def create_module(grade_lobject, module_title, module_structure)
          Lobject.transaction do
            return unless Lobject.by_title(module_title).empty?

            root_lobject = LobjectBuilder.new
              .set_organization(Organization.unbounded)
              .add_title(module_title)
              .save!

            grade_lobject.curriculum_map_collection.add_child(root_lobject).save!

            create_units(root_lobject, module_structure)
          end
        end

        def create_units(module_lobject, module_structure)
          Lobject.transaction do
            grade_collection = module_lobject.curriculum_map_collection

            module_structure.each do |unit_title, lesson_count|
              return unless Lobject.by_title(unit_title).empty?

              unit = LobjectBuilder.new
                .set_organization(Organization.unbounded)
                .add_title(unit_title)
                .save!

              puts "#{unit.id} - #{unit.title}"

              grade_collection.add_child(unit, parent: module_lobject)

              lesson_count.times do |i|
                lesson_no = i+1

                lesson = LobjectBuilder.new
                  .set_organization(Organization.unbounded)
                  .add_title("#{unit_title}, Lesson #{lesson_no}")
                  .save!

                  puts "#{lesson.id} - #{lesson.title}"

                grade_collection.add_child(lesson, parent: unit)
              end
            end

            grade_collection.save!
          end
        end

        def remove_superfluous_text_from_descriptions
          str_regex = 'in order to assist educators with the implementation of the common core, the new york state education department provides curricular (materials|modules) in P-12 english language arts and mathematics[[:space:]]that schools and districts can adopt or adapt for local purposes\.\ '
          regex     = /#{str_regex}/i

          LobjectDescription.where('description ~* ?', str_regex).each do |lobject_description|
            lobject_description.update_column(:description, lobject_description.description.gsub(regex, ''))
          end
        end

        def remove_styles_from_descriptions
          LobjectDescription.where("description ~ '(class|style)='").each do |lobject_description|
            doc = Nokogiri::HTML(lobject_description.description)
            doc.css('[class], [style]').each do |node|
              node.remove_attribute('class')
              node.remove_attribute('style')
            end
            doc.xpath('//comment()').remove
            lobject_description.update_column(:description, doc.to_s)
          end
        end
      end
    end
  end
end
