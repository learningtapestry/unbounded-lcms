require 'date'
require 'set'

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

class EngagenyImporter
  class << self
    def find_lobject_by_nid(nid)
      Content::Models::Lobject.find_by_sql([%{
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
      unless lob = Content::Models::Lobject.includes(:lobject_titles).where(lobject_titles: { title: title }).first
        lob = Content::Models::Lobject.create(hidden: true)
        lob.lobject_titles << Content::Models::LobjectTitle.new(title: title)
      end
      lob
    end

    def import_node(eny_node)
      return if Content::Models::EngagenyDocument.where(nid: eny_node.nid).size > 0

      eny_doc = Content::Models::EngagenyDocument.new

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
      .each{ |r| standards[r.vocabulary_name] << r.name }

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

      return if Content::Models::LobjectCollection.where(lobject_id: root_lob.id).size > 0

      col = Content::Models::LobjectCollection.create(lobject_id: root_lob.id)

      nids.each_with_index do |nid, i|
        Content::Models::LobjectChild.create(
          parent: root_lob, 
          collection: col, 
          child: find_lobject_by_nid(nid),
          position: i
        )
      end
    end

    def import_collection(collection_hash, collection = nil)
      if collection_hash[:items].keys.size > 0
        lobject = find_lobject_by_nid(collection_hash[:nid])

        return if lobject.lobject_collections.size > 0

        unless collection
          collection = Content::Models::LobjectCollection.new(lobject: lobject)
        end

        i = 0
        collection_hash[:items].sort_by { |k,v| v[:weight] }.each do |mlid, child_hash|
          i += 1
          child_lob = find_lobject_by_nid(child_hash[:nid])
          Content::Models::LobjectChild.create(
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
          Content::Models::LobjectRelatedLobject.create(
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
        'ELA Curriculum Map',
        [26661, 27791, 27786, 27781, 8421, 25011, 25021, 25096, 25131, 25141, 26211, 26266, 26491, 27801]
      )

      create_collection_for_nids(
        'Math Curriculum Map',
        [28461, 24991, 26481, 26486, 25601, 26496, 26501, 25836, 26216, 26271, 26276, 26281, 27041, 27046]
      )

      import_related_lobjects
    end
  end
end
