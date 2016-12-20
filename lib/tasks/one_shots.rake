class ResourceColumn
  attr_reader :resource, :old_value, :new_value

  def initialize(resource, old_value, new_value)
    @resource = resource
    @old_value = old_value
    @new_value = new_value
  end

  def different?
    @old_value != @new_value
  end

  def to_s
    "#{resource.id} $$ #{old_value} $$ #{new_value}"
  end
end

class ResourceDiffer
  attr_reader :row

  def initialize(row)
    @row = row
  end

  def self.columns
    [
      #:text,
      #:author,
      :title,
      :teaser,
      :subtitle,
      :grades,
      :standards,
      :resource_types,
      :subjects,
      :content_sources,
      :keywords,
      :writing_type,
      :ell_appropriate,
      :time_to_teach,
      :additional_resources,
      #:topics,
      :related_resources
    ]
  end

  def resource
    if row['ID Our Database'].present?
      @resource ||= Resource.find(row['ID Our Database'])
    end
  end

  def text
    new_value = row['Text'].to_s.strip.squeeze(' ')
    old_value = ''
    ResourceColumn.new(resource, old_value, new_value)
  end

  def author
    new_value = row['Author'].to_s.strip.squeeze(' ')
    old_value = ''
    ResourceColumn.new(resource, old_value, new_value)
  end

  def title
    old_value = resource.title.to_s.strip
    new_value = row['Title on Site'].to_s.strip.squeeze(' ')
    if new_value.blank?
      new_value = row['Title Hierarchy'].to_s.strip
    end
    ResourceColumn.new(resource, old_value, new_value)
  end

  def teaser
    new_value = row['Teaser Text'].to_s.strip.squeeze(' ')
    old_value = resource.teaser.to_s.strip
    new_value = old_value if new_value.blank?
    ResourceColumn.new(resource, old_value, new_value)
  end

  def subtitle
    new_value = row['Subtitle'].to_s.strip.squeeze(' ')
    old_value = resource.subtitle.to_s.strip
    ResourceColumn.new(resource, old_value, new_value)
  end

  def grades
    new_value = row['Grades'].to_s.split(',').map(&:strip).uniq.sort.join(', ').squeeze(' ')
    old_value = resource.grade_list.uniq.sort.join(', ').to_s.strip
    ResourceColumn.new(resource, old_value, new_value)
  end

  def standards
    new_value = row['Standards'].to_s.strip.split(',').map do |std|
      std.strip.downcase.gsub('math.', '').gsub('ela.', '')
    end.uniq.sort.join(', ').squeeze(' ')
    old_value = resource.standards.pluck(:name).uniq.sort.join(', ').to_s.strip
    ResourceColumn.new(resource, old_value, new_value)
  end

  def resource_types
    new_value = row['Resource Types'].to_s.split(',').map(&:strip).uniq.sort.join(', ').squeeze(' ')
    old_value = resource.resource_type_list.uniq.sort.join(', ').to_s.strip
    ResourceColumn.new(resource, old_value, new_value)
  end

  def subjects
    new_value = row['Subjects'].to_s.split(',').map(&:strip).uniq.select { |t| t != 'math' && t != 'english language arts' }.sort.join(', ').squeeze(' ')
    old_value = resource.tag_list.uniq.sort.join(', ').to_s.strip
    new_value = old_value if new_value.blank?
    ResourceColumn.new(resource, old_value, new_value)
  end

  def content_sources
    new_value = row['Content Source'].to_s.split(',').map(&:strip).uniq.sort.join(', ').squeeze(' ')
    old_value = resource.content_source_list.uniq.sort.join(', ').to_s.strip
    ResourceColumn.new(resource, old_value, new_value)
  end

  def keywords
    new_value = row['Keyword (Topic or Theme) [Most essential]'].to_s.split(',').map(&:strip).uniq.sort.join(', ').squeeze(' ')
    old_value = ''
    ResourceColumn.new(resource, old_value, new_value)
  end

  def writing_type
    new_value = row['Writing Type (Writing Assignments)'].to_s.strip.squeeze(' ')
    old_value = ''
    ResourceColumn.new(resource, old_value, new_value)
  end

  def ell_appropriate
    new_value = row['Resources for ELLs'].to_s.strip.squeeze(' ')
    old_value = resource.ell_appropriate
    new_value = old_value if new_value.blank?
    ResourceColumn.new(resource, old_value, new_value)
  end

  def time_to_teach
    new_value = row['Time to Teach (Unit, Module, Domain)'].to_s.strip.squeeze(' ')
    old_value = resource.time_to_teach.to_s.strip
    new_value = old_value if new_value.blank?
    ResourceColumn.new(resource, old_value, new_value)
  end

  def additional_resources
    new_value = row['Additional Resources'].to_s.split(',').map(&:strip).map(&:to_i).uniq.sort.join(', ').squeeze(' ')
    old_value = resource.resource_additional_resources.pluck(:additional_resource_id).uniq.sort.join(', ').to_s.strip
    ResourceColumn.new(resource, old_value, new_value)
  end

  def topics
    new_value = row['Topics'].to_s.split(',').map(&:strip).uniq.sort.join(', ').squeeze(' ')
    old_value = resource.topic_list.uniq.sort.join(', ').to_s.strip
    new_value = old_value if new_value.blank?
    ResourceColumn.new(resource, old_value, new_value)
  end

  def related_resources
    new_value = row['Related Resources'].to_s.split(',').map(&:strip).map(&:to_i).uniq.sort.join(', ').squeeze(' ')
    old_value = resource.resource_related_resources.pluck(:related_resource_id).uniq.sort.join(', ').to_s.strip
    ResourceColumn.new(resource, old_value, new_value)
  end

end


def fill_resource(resource, row)
  if row['title'].present?
    resource.title = row['title']
  end

  if row['teaser'].present?
    resource.teaser = row['teaser']
  end

  if row['description'].present?
    resource.description = row['description']
  end
end

def clean_str(str)
  str.gsub(/\u2028/, '')
end

def format_str(str)
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper

  str = str.strip

  should_format = (strip_tags(str).size == str.gsub('&', '&amp;').size) &&
                   (str.include?("\n") || str.include?("\r"))
  if should_format
    str = simple_format(str)
  end

  str
end

def import_csv(file)
  CSV.readlines(file, headers: true).each do |l|
    next unless l['id'].present?

    res = Resource.find(l['id'])
    columns = []

    if l['title'].present?
      columns << 'title'
      res.title = clean_str( l['title'] )
    end

    if l['teaser'].present?
      columns << 'teaser'
      res.teaser = clean_str( l['teaser'] )
    end

    if l['description'].present?
      columns << 'description'
      res.description = format_str( clean_str( l['description'] ) )
    end

    res.save!

    puts "Imported #{columns.join(',')} #{res.id}."
  end
end

def import_csv_with_children(file)
  last_resource = nil

  CSV.readlines(file, headers: true).each do |row|
    if row['id'].blank?
      return if last_resource.nil?

      res = Resource.new
      fill_resource(res, row)
      res.save!

      cur = last_resource.curriculums_as_parent.first
      cur.add_child(res)
    else
      res = Resource.find(row['id'])
      fill_resource(res, row)
      res.save!
      last_resource = res

      puts "Imported #{res.id}."
    end
  end
end

def verify_csv(file)
  CSV.readlines(file, headers: true).each do |l|
    next unless l['id'].present?

    res = Resource.find(l['id'])

    puts "Checking #{res.id}"

    if l['title'].present?
      if res.title == l['title']
        puts "Title looks OK." 
      else
        puts "Title looks bad!"
      end
    end

    if l['teaser'].present?
      if res.teaser == l['teaser']
        puts "Teaser looks OK." 
      else
        puts "Teaser looks bad!"
      end
    end

    if l['description'].present?
      if res.description == l['description']
        puts "Description looks OK." 
      else
        puts "Description looks bad!"
      end
    end
  end
end

namespace :one_shots do
  task generate_teasers: [:environment] do
    include ActionView::Helpers::TextHelper

    Resource.find_each do |r|
      if r.description.present?
        r.teaser = truncate(r.text_description, length: 200)
        r.save!
      end
    end
  end

  task update_standard_names: [:environment] do
    Standard.where(subject: 'math').find_each do |s|
      s.update_attributes(name: s.name.gsub('Math.', ''))
    end

    Standard.where(subject: 'ela').find_each do |s|
      s.update_attributes(name: s.name.gsub('ELA.', ''))
    end
  end

  task generate_domains_and_clusters: [:environment] do
    Standard.where(subject: 'math').find_each do |s|
      pieces = s.name.split('.')

      domain_n = pieces[1]
      cluster_n = pieces[0..-2].join('.')

      if domain_n.present?
        domain = StandardDomain.find_or_create_by(name: domain_n)
        s.standard_domain = domain
      end

      if cluster_n.present?
        cluster = StandardCluster.find_or_create_by(name: cluster_n)
        s.standard_cluster = cluster
      end

      s.save!
    end
  end

  task generate_clusters: [:environment] do
    CSV.foreach('clusters.csv', headers: true) do |l|
      std_name = l['standard'].downcase.gsub('.', '')
      cluster_name = l['cluster'].downcase.gsub('.', '')

      std = CommonCoreStandard.where_alt_name(std_name).first

      if std.nil?
        puts "Couldn't find std #{std_name}"
        next
      end

      cluster = CommonCoreStandard.where_alt_name(cluster_name)
        .where(label: 'cluster').first

      if cluster.nil?
        puts "Couldn't find cluster #{cluster_name}"
        next
      end 

      puts "Found std #{std.name} for std_name #{std_name}"
      puts "Found cluster #{cluster.name} for cls_name #{cluster_name}"

      std.cluster_id = cluster.id

      std.save!
    end
  end

  task generate_domains: [:environment] do
    CommonCoreStandard.where(label: 'standard', subject: 'math').find_each do |std|
      next unless std.name

      name = std.name.gsub('ccss.math.content.', '')
      guessed_domain = name.split('.')[1].downcase.strip

      domain = CommonCoreStandard.find_by(name: guessed_domain)

      if domain.nil?
        puts "Couldn't find domain #{guessed_domain} for std #{std.name}"
        next
      end

      std.domain_id = domain.id
      std.save!

      puts "Associated std #{std.name} with domain #{domain.name}"
    end
  end

  task add_eny: [:environment] do
    CSV.open('with_eny.csv', 'wb') do |csv|
      CSV.foreach('ids.csv', headers: true) do |row|
        r = Resource.find(row[0])
        csv << [row[0], r.engageny_url]
      end
    end
  end

  task import_math_standards: [:environment] do
    CSV.foreach('standards.csv', headers: true) do |row|
      std = Standard.find_or_create_by(name: row[3].downcase, subject: 'math')

      if row[1].present? && cluster = row[1].downcase
        std.standard_cluster = StandardCluster.find_or_create_by(name: cluster)
      end

      if row[2].present? && emphasis = row[2].downcase
        std.emphasis = emphasis
      end

      std.save!
    end
  end

  task process_zimba_diagram: [:environment] do
    CSV.open('zimba_easy.csv', 'wb') do |csv|
      CSV.foreach('zimba.csv', headers: true) do |row|
        link_type = row[0]
        link_begin = row[1]
        link_end = row[2]

        link_type = link_type.strip == 'Arrow' ? 'a' : 'n'
        link_begin, link_description = link_begin.split('||')[0..1]
        link_begin = link_begin.split(';')
        link_begin = link_begin.map do |std|
          expansions = std.split(',')

          if expansions.size > 1
            prefix = (expansions[0].split('.')[0..-2]).join('.')
            
            expansions = [expansions[0]] + expansions[1..-1].map do |e|
              "#{prefix}.#{e}"
            end
          end

          expansions
        end.flatten

        link_end, link_description = link_end.split('||')[0..1]
        link_end = link_end.split(';')
        link_end = link_end.map do |std|
          expansions = std.split(',')

          if expansions.size > 1
            prefix = (expansions[0].split('.')[0..-2]).join('.')
            
            expansions = [expansions[0]] + expansions[1..-1].map do |e|
              "#{prefix}.#{e}"
            end
          end

          expansions
        end.flatten

        link_begin.each do |lb|
          link_end.each do |le|
            link_type = if lb[0] != le[0] && link_type == 'a'
              'ga'
            else
              link_type
            end

            csv << [
              link_type,
              lb,
              le,
              link_description
            ]
          end
        end
      end
    end
  end

  task import_zimba_diagram: [:environment] do
    ActiveRecord::Base.transaction do
      CSV.foreach('zimba_easy.csv') do |row|
        link_type = case row[0]
                    when 'ga' then 'gp'
                    when 'a' then 'p'
                    when 'n' then 'c'
                    end

        std_begin = Standard.find_or_create_by(
          name: row[1].downcase,
          subject: 'math'
        )

        std_end = Standard.find_or_create_by(
          name: row[2].downcase,
          subject: 'math'
        )

        StandardLink.create(
          link_type: link_type,
          standard_begin: std_begin,
          standard_end: std_end,
          description: row[3]
        )
      end
    end
  end

  task generate_time_to_teach: [:environment] do
    ActiveRecord::Base.transaction do
      Curriculum.lessons.with_resources.find_each do |cur|
        res = cur.resource
        next if res.time_to_teach.present? && res.time_to_teach != 0
        cur.resource.update_attributes(time_to_teach: 60)
      end

      Curriculum.units.with_resources.find_each do |cur|
        total = cur.children.map { |c| c.resource.time_to_teach }.sum
        cur.resource.update_attributes(time_to_teach: total)
      end

      Curriculum.modules.with_resources.find_each do |cur|
        total = cur.children.map { |c| c.resource.time_to_teach }.sum
        cur.resource.update_attributes(time_to_teach: total)
      end

      Curriculum.grades.with_resources.find_each do |cur|
        total = cur.children.map { |c| c.resource.time_to_teach }.sum
        cur.resource.update_attributes(time_to_teach: total)
      end

      Curriculum.maps.seeds.find_each do |cur|
        total = cur.children.map { |c| c.resource.time_to_teach }.sum
        cur.resource.update_attributes(time_to_teach: total)
      end
    end
  end

  task generate_res_subject: [:environment] do
    Resource.transaction do
      Resource.find_each do |r|
        subject = if r.math?
          'math'
        elsif r.ela?
          'ela'
        else
          nil
        end

        r.update_attributes(subject: subject)
      end
    end
  end

  task migrate_tags: [:environment] do
    # :content_sources,
    # :file_types,
    # :grades,
    # :resource_types,
    # :tags,
    # :topics

    ActiveRecord::Base.transaction do
      ResourceGrade.find_each do |item|
        r = item.resource
        r.grade_list.add(item.grade.name)
        r.save!
      end

      ResourceResourceType.find_each do |item|
        r = item.resource
        r.resource_type_list.add(item.resource_type.name)
        r.save!
      end

      ResourceTopic.find_each do |item|
        r = item.resource
        r.topic_list.add(item.topic.name)
        r.save!
      end

      ResourceSubject.find_each do |item|
        r = item.resource
        r.tag_list.add(item.subject.name)
        r.save!
      end
    end
  end

  task generate_download_types: [:environment] do
    ActiveRecord::Base.transaction do
      Resource.find_each do |r|
        r.update_download_types
        if r.download_type_list.size > 0
          r.save!
        end
      end
    end
  end

  task generate_standard_strands: [:environment] do
    ActiveRecord::Base.transaction do
      Standard.find_each do |std|
        pieces = std.name.split('.')
        if ['rl', 'ri', 'rf', 'rh', 'rst', 'w', 'sl', 'l'].include?(pieces[0])
          strand = StandardStrand.find_or_create_by!(name: pieces[0])
          std.update_attributes(standard_strand_id: strand.id)
        end
      end
    end
  end

  task diff_resources: [:environment] do
    ActiveRecord::Base.transaction do
      lines = CSV.readlines('final.csv', headers: true)
      CSV.open('differences.csv', 'wb', col_sep: '%') do |csv|
        lines.each do |l|
          next if l[0].blank?
          differ = ResourceDiffer.new(l)
          ResourceDiffer.columns.each do |col|
            diffed_col = differ.send(col)
            if diffed_col.different?
              csv << [col, differ.resource.id, diffed_col.old_value, diffed_col.new_value]
            end
            # if differ.text.new_value.present?
            #   authors = differ.author.new_value.split(',').map(&:strip)
            #   texts = differ.text.new_value.split(',').map(&:strip)
            #   puts "#{authors} //// #{texts}" if authors.size != texts.size
            # end
          end
        end
      end
    end
  end

  task remove_ela_math_subjects: [:environment] do
    Resource.transaction do
      Resource.find_each do |r|
        tag_list = r.tag_list
        next if tag_list.empty?

        tag_list = tag_list.select { |t| t != 'math' && t != 'english language arts' }

        r.tag_list = tag_list
        r.save!
      end
    end
  end

  task import_read_assgn: [:environment] do
    Resource.transaction do
      lines = CSV.readlines('final_text_author.csv', headers: true)
      lines.each do |l|
        next if l[0].blank?
        differ = ResourceDiffer.new(l)
        if differ.text.new_value.present?
          author_line = CSV.parse_line(differ.author.new_value, quote_char: '$')
          text_line = CSV.parse_line(differ.text.new_value, quote_char: '$')

          text_line.each_with_index do |text_col, i|
            text_col = text_col.gsub('$', '').gsub('~', "'").gsub('_', '"').squeeze(' ').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
            if author_line.present?
              author_col = author_line[i]
              puts author_col
              author_col = author_col.gsub('$', '').gsub('~', "'").gsub('_', '"').squeeze(' ').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
              author = ReadingAssignmentAuthor.find_or_create_by!(name: author_col)
            else
              author = ReadingAssignmentAuthor.find_or_create_by!(name: 'Unknown')
            end

            text = ReadingAssignmentText.find_or_create_by!(
              name: text_col,
              reading_assignment_author: author
            )
            differ.resource.reading_assignments.create!(
              reading_assignment_text: text 
            )
          end
        end
      end
    end
  end

  task import_read_assgn_2: [:environment] do
    Resource.transaction do
      lines = CSV.readlines('0502_Grade 5 ELA-Title Author GH COMPLETE LT.csv')
      lines.each do |l|
        next if l[0].blank?
        next if l[1].blank?
        next if l[2].blank?

        resource = Resource.find(l[0])

        puts '----'
        puts resource.id
        author_line = CSV.parse(l[2], col_sep: ';'); puts author_line.inspect
        text_line = CSV.parse(l[1], col_sep: ';'); puts text_line.inspect
        puts text_line[0].size
        puts '-----'

        author_line = author_line[0]
        text_line = text_line[0]

        text_line.each_with_index do |text_col, i|
          text_col = text_col.squeeze(' ').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
          if author_line.present?
            author_col = author_line[i]
            puts "#{text_col} by #{author_col}"
            author_col = author_col.squeeze(' ').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
            author = ReadingAssignmentAuthor.find_or_create_by!(name: author_col)
          else
            author = ReadingAssignmentAuthor.find_or_create_by!(name: 'Unknown')
          end

          text = ReadingAssignmentText.find_or_create_by!(
            name: text_col,
            reading_assignment_author: author
          )
          resource.reading_assignments.create!(
            reading_assignment_text: text 
          )
        end
      end
    end
  end

  def merge_standard(main_standard, alt_standard)
    main_standard.name = alt_standard.name
    #main_standard.created_at = alt_standard.created_at
    #main_standard.updated_at = alt_standard.updated_at
    main_standard.subject = alt_standard.subject
    #main_standard.emphasis = alt_standard.emphasis
    #main_standard.standard_strand_id = alt_standard.standard_strand_id
    main_standard.alt_names = alt_standard.alt_names
    main_standard.asn_identifier = alt_standard.asn_identifier
    main_standard.description = alt_standard.description
    main_standard.grades = alt_standard.grades
    main_standard.label = alt_standard.label

    alt_standard.destroy!
    main_standard.save!
  end

  def is_number? string
    true if Float(string) rescue false
  end

  task merge_standards_alt_name: [:environment] do
    Standard.transaction do
      Standard.where(asn_identifier: nil).find_each do |standard|
        if api_std = Standard.where("'#{standard.name}' = ANY (alt_names)").first
          puts "Found a main std #{api_std.name} with alt notation #{api_std.alt_names} == #{standard.name}."

          if api_std.id > standard.id
            merge_standard(standard, api_std)
          else
            standard.destroy!
          end
        end
      end
    end
  end

  task merge_standards_math_content: [:environment] do
    Standard.transaction do
      Standard.where('name ilike ?', '%.content%').find_each do |api_std|
        main_name = api_std.name.gsub('ccss.math.content.', '').gsub('-', '.')
        if other_std = Standard.where(name: main_name).first
          puts api_std.name
          puts "Found a std #{api_std.name} that matches #{other_std.name}."

          if api_std.id < other_std.id
            other_std.destroy!
          end
        end
      end
    end
  end

  task merge_standards_ela_numeric: [:environment] do
    Standard.transaction do
      Standard.where(asn_identifier: nil, subject: 'ela').find_each do |std|
        next unless is_number?(std.name[0])
        # 11-12.rh.9 wrong
        # ccss.ela-literacy.rh.11-12.9 right
        pieces = std.name.split('.')
        correct_name = "ccss.ela-literacy.#{pieces[1]}.#{pieces[0]}.#{pieces[2]}"
        puts std.name
        puts correct_name

        if alt_std = Standard.where(name: correct_name).first
          puts "Found a std #{alt_std.id} #{alt_std.name} matching std #{std.id} #{std.name}."
          merge_standard(std, alt_std)
        end
      end
    end
  end

  task generate_alt_names: [:environment] do
    CommonCoreStandard.transaction do
      CommonCoreStandard.find_each do |std|
        std.generate_alt_names
        std.save!
      end
    end
  end

  task generate_breadcrumbs: [:environment] do
    Curriculum.trees.find_each { |c| c.generate_breadcrumb_pieces ; c.save! ; puts "#{c.id} #{c.resource.title} #{c.breadcrumb_piece} #{c.breadcrumb_short_piece}" }
    Curriculum.trees.find_each { |c| c.generate_breadcrumb_titles ; c.save! ; puts "#{c.id} #{c.resource.title} #{c.breadcrumb_title} #{c.breadcrumb_short_title}" }
  end

  task import_new_fields: [:environment] do
    lines = CSV.readlines('new_ela_fields_2.csv')
    lines.each do |l|
      next if l[0].blank?

      res = Resource.find(l[0])
      changed = false

      if l[1].present?
        res.title = l[1]
        changed = true
      end

      if l[2].present?
        res.teaser = l[2]
        changed = true
      end

      if l[3].present?
        res.description = l[3]
        changed = true
      end

      if changed
        res.save!
        puts "Saved res with id #{res.id}."
      end
    end
  end


  task export_1: [:environment] do
    CSV.open('amazon_export.csv', 'wb') do |csv|
      Curriculum.ela_tree.self_and_descendants.each do |desc|
        res = desc.resource
        csv << [
          res.id,
          "https://ub-development.learningtapestry.com/resources/#{res.id}",
          desc.breadcrumb_title,
          res.title,
          res.short_title,
          res.subtitle,
          res.teaser,
          res.text_description,
          res.time_to_teach,
          res.subject,
          res.ell_appropriate,
          res.resource_type,
          res.url,
          res.grade_list.join(','),
          res.resource_type_list.join(','),
          res.tag_list.join(','),
          res.topic_list.join(','),
          res.standards.pluck(:name).join(','),
          res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.name }.join(','),
          res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.reading_assignment_author.name }.join(',')
        ]
      end

      Curriculum.math_tree.self_and_descendants.each do |desc|
        res = desc.resource
        csv << [
          res.id,
          "https://ub-development.learningtapestry.com/resources/#{res.id}",
          desc.breadcrumb_title,
          res.title,
          res.short_title,
          res.subtitle,
          res.teaser,
          res.text_description,
          res.time_to_teach,
          res.subject,
          res.ell_appropriate,
          res.resource_type,
          res.url,
          res.grade_list.join(','),
          res.resource_type_list.join(','),
          res.tag_list.join(','),
          res.topic_list.join(','),
          res.standards.pluck(:name).join(','),
          res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.name }.join(','),
          res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.reading_assignment_author.name }.join(',')
        ]
      end
    end
  end

  task export_2: [:environment] do
    CSV.open('export_2.csv', 'wb') do |csv|
      Curriculum.ela_tree.self_and_descendants.each do |desc|
        res = desc.resource
        csv << [
          res.id,
          res.engageny_url,
          desc.breadcrumb_title,
          res.title,
          res.teaser,
          res.text_description,
          res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.name }.join(','),
          res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.reading_assignment_author.name }.join(',')
        ]
      end
    end
  end

  def to_csv_array(cur)
    res = cur.resource

    [
      res.id,
      "https://www.unbounded.org/resources/#{res.id}",
      cur.breadcrumb_title,
      res.title,
      res.short_title,
      res.subtitle,
      res.teaser,
      res.text_description,
      res.time_to_teach,
      res.subject,
      res.ell_appropriate,
      res.resource_type,
      res.grade_list.join(','),
      res.resource_type_list.join(','),
      res.tag_list.join(','),
      res.topic_list.join(','),
      res.standards.pluck(:name).join(','),
      res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.name }.join(','),
      res.resource_reading_assignments.map { |ra| ra.reading_assignment_text.reading_assignment_author.name }.join(',')
    ]
  end

  task export_3: [:environment] do
    ela = [14147, 15503, 16259]
    math = [11973, 12934, 13385]

    CSV.open('amazon_3.csv', 'wb') do |csv|
      (ela + math).each do |id|
        cur = Curriculum.find(id)

        cur.children.each do |mod|
          csv << to_csv_array(mod)

          mod.children.each do |unit|
            csv << to_csv_array(unit)
          end
        end
      end
    end
  end

  task export_4: [:environment] do
    c = Resource.where(title: 'Grade 3 Mathematics').first.curriculums.trees.first
    CSV.open('grade_3_math.csv', 'wb') { |csv| c.self_and_descendants.each { |cc| csv << to_csv_array(cc) } }
  end

  task import_csv: [:environment] do
    csv_file = ENV['CSV_FILE']
    import_csv(csv_file)
  end

  task import_csv_folder: [:environment] do
    csv_folder = ENV['CSV_FOLDER']
    Dir.glob("#{csv_folder}/*.csv") do |csv_file|
      puts "-----"
      puts "IMPORTING #{csv_file}."
      import_csv(csv_file)
      puts "-----"
    end
  end

  task verify_csv_folder: [:environment] do
    csv_folder = ENV['CSV_FOLDER']
    Dir.glob("#{csv_folder}/*.csv") do |csv_file|
      puts "-----"
      puts "VERIFYING #{csv_file}."
      verify_csv(csv_file)
      puts "-----"
    end
  end

  task import_emphasis: [:environment] do
    CSV.readlines('emphasis.csv', headers: true).each do |l|
      std_name = l['standard']
      std_emphasis = l['emphasis'].downcase
      std_emphasis = 'plus' if std_emphasis == '+'
      puts "#{std_name} #{std_emphasis}"
      std = Standard.where('? = ANY(alt_names)', std_name.downcase).first
      raise StandardError unless std

      std.emphasis = std_emphasis
      std.save!
    end
  end

  task generate_content_sources: [:environment] do
    Resource.find_each do |r|
      r.generate_content_sources
      r.save!
    end
  end

  task delete_resources: [:environment] do
    file = ENV['CSV_FILE']
    Resource.transaction do
      CSV.readlines(file, headers: true).each do |l|
        r = Resource.where(id: l[0]).first
        if r
          r.destroy!
        else
          puts "#{l[0]} was not found" 
        end
      end
    end
  end

  task import_csv_with_children: [:environment] do
    file = ENV['CSV_FILE']
    import_csv_with_children(file)
  end

  task try_to_find_shitty_bug: [:environment] do
    File.open('try_to_find_shitty_bug', 'wb') do |fl|
      Resource.find(4875).curriculums.trees.first.self_and_descendants.each do |c|
        r = c.resource
        fl << %{eval({"title": #{r.title.to_json}, "teaser": #{r.teaser.to_json}, "description": #{r.description.to_json}});\n}
      end
    end
  end

  task add_emphasis_to_clusters: [:environment] do
    CommonCoreStandard.standards
      .where.not(cluster_id: nil)
      .pluck(:emphasis, :cluster_id)
      .uniq
      .each do |(emphasis, cluster_id)|
        Standard.find(cluster_id).update_attributes(emphasis: emphasis)
      end
  end

  task replace_newline_descriptions: [:environment] do
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::TextHelper

    Curriculum.maps.trees.each do |map|
      map.self_and_descendants.each do |cur|
        res = cur.resource
        desc = res.description

        next unless desc

        should_replace = (strip_tags(desc).size == desc.gsub('&', '&amp;').size) &&
                         (desc.include?("\n") || desc.include?("\r"))

        if should_replace
          new_desc = simple_format(desc)
          res.update_attributes(description: new_desc)
          puts "Removed newlines for description: #{res.id} #{new_desc}"
        end

      end
    end
  end

  task generate_aws_commands_for_new: [:environment] do
    dls = [] ; Resource.where(engageny_url: [
      'https://www.engageny.org/resource/network-team-institute-materials-november-26-29-2012-grades-6-12-math-curriculum-pd-day-two-session-thursday',
      'https://www.engageny.org/resource/test-upload',
      'https://www.engageny.org/resource/grade-4-ela-module-4',
      'https://www.engageny.org/resource/preschool-domain-1-all-about-me-teacher-guide',
      'https://www.engageny.org/resource/preschool-domain-1-all-about-me-flip-book',
      'https://www.engageny.org/resource/preschool-domain-1-all-about-me-activity-pages',
      'https://www.engageny.org/resource/preschool-domain-1-all-about-me-transition-and-learning-center-cards',
      'https://www.engageny.org/resource/grade-4-ela-module-2b-unit-2-lesson-2',
      'https://www.engageny.org/resource/grade-4-ela-module-2b-unit-2-lesson-2',
      'https://www.engageny.org/resource/grade-4-ela-module-2b-unit-2-lesson-1',
      'https://www.engageny.org/resource/grade-4-ela-module-2b-unit-2-lesson-1',
      'https://www.engageny.org/resource/grade-4-ela-module-2b-unit-2-lesson-3',
      'https://www.engageny.org/resource/grade-4-ela-module-2b-unit-2-lesson-3',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-4-flip-book-plants',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-4-image-card-set-plants',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-4-supplemental-guide-plants',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-5-anthology-farms',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-5-flip-book-farms',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-6-flip-book-native-americans',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-6-image-card-set-native-americans',
      'https://www.engageny.org/resource/kindergarten-listening-learning-domain-6-supplemental-guide-native-americans',
      'https://www.engageny.org/resource/february-2014-nti-grades-6-12-math-turnkey-kit-network-teams-session-1',
      'https://www.engageny.org/resource/july-2014-nti-benchmarking-change-process-where-are-we-now',
      'https://www.engageny.org/resource/algebra-ii-module-2-topic-a-lesson-2-0'
    ]).each do |r|
     r.downloads.each { |dl| dls << dl }
    end

    dls.each do |download|
      bucket_url = download.url.sub('public://', '')
      filename = download.title
      command = "aws --profile unbounded s3 cp s3://k12-content/#{bucket_url} s3://unbounded-uploads/attachments/#{download.id}/#{filename}"
      puts command
    end
  end

  task generate_aws_commands: [:environment] do
    File.open('/tmp/aws_commands.sh', 'wb') do |aws_commands|
      Download.where.not(url: nil).select(:id, :url, :filename).find_each do |download|
        bucket_url = download.url.sub('public://', '')
        filename = download.file.file.filename
        command = "aws --profile unbounded s3 cp s3://k12-content/#{bucket_url} s3://unbounded-uploads/attachments/#{download.id}/#{filename}"
        puts command
      end
    end
  end

  def aws_command(obj, accessor, prefix)
    file = obj.send(accessor)

    file_url = "$STACK_PATH/public/uploads/#{prefix}/#{obj.id}/#{file.file.filename}"
    bucket_url = "s3://unbounded-uploads-development/#{prefix}/#{obj.id}/#{file.file.filename}"

    "aws --profile unbounded s3 cp #{file_url} #{bucket_url}"
  end

  task generate_aws_copy_commands: [:environment] do
    #content_guide_image
    #resource_backup
    #content_guide
    #content_guide
    #resource
    #download
    #staff_member

    ContentGuideImage.find_each do |obj|
      puts aws_command(obj, :file, 'content_guide_images')
    end

    ResourceBackup.find_each do |obj|
      puts aws_command(obj, :dump, 'resource_backups')
    end

    ContentGuide.find_each do |obj|
      puts aws_command(obj, :big_photo, 'content_guides')
      puts aws_command(obj, :small_photo, 'content_guides')
    end

    Resource.where.not(image_file: nil).find_each do |obj|
      puts aws_command(obj, :image_file, 'resource_images')
    end

    Download.where(url: nil).find_each do |obj|
      puts aws_command(obj, :file, 'attachments')
    end
  end


  #def self.create_from_resource(resource, curriculum_type:)
   # create(
   #   item: resource,
   #   curriculum_type: curriculum_type
   # )
  #end

  task import_6_8: [:environment] do
    def parse_resource_from_row(row)
      level = row[3].try(:strip).try(:downcase)
      number_value = row[4].try(:strip).try(:downcase)
      title = row[6].try(:strip)

      if title.blank?
        title = row[5].try(:strip)
      end

      teaser = row[7].try(:strip)
      description = row[8].try(:strip)
      grade = row[9].try(:strip).try(:downcase)

      short_title = if level == 'module'
        'core proficiencies'
      elsif level == 'lesson'
        "part #{number_value}".strip
      else
        "#{level} #{number_value}".strip
      end
      grades = grade.split(',').map(&:strip).map { |str| "grade #{str}" }

      res = Resource.create(
        title: title,
        teaser: teaser,
        description: description,
        short_title: short_title,
        grade_list: grades,
        subject: 'ela',
        time_to_teach: 60
      )

      puts "#{res.id} - #{res.title}"

      res
    end

    state = nil
    grade_cur = nil
    module_cur = nil
    unit_cur = nil

    require 'set'
    grade_curs = Set.new

    file = ENV['CSV_FILE']

    Resource.transaction do
      CSV.readlines(file).each_with_index do |row,i|
        level = row[3].strip.downcase
        state = if level == 'module'
                  :module
                elsif level == 'unit'
                  :unit
                elsif level == 'lesson'
                  :lesson
                else
                  puts level
                  raise StandardError.new('level probl')
                end

        resource = parse_resource_from_row(row)

        if state == :module
          grade_cur = Curriculum
            .grades
            .where_grade(resource.grades.first.name)
            .where_subject(:ela)
            .where(parent_id: nil, seed_id: nil)
            .first

          grade_curs.add(grade_cur.id.to_i)

          module_cur = Curriculum.create(
            item: resource,
            curriculum_type: CurriculumType.module
          )
          puts "Module #{module_cur.id}"
          grade_cur.add_child(module_cur)

        elsif state == :unit
          unit_cur = Curriculum.create(
            item: resource,
            curriculum_type: CurriculumType.unit
          )
          puts "Unit #{unit_cur.id}"
          module_cur.add_child(unit_cur)

        elsif state == :lesson
          unit_cur.add_child(resource)
        end
      end

      grade_curs.each do |id|
        cur = Curriculum.find(id)
        puts "Updating trees for cur. #{cur.resource.title}"
        cur.update_trees
      end
    end
  end

  task import_9_12: [:environment] do
    def parse_resource_from_row(row)
      level = row[1].try(:strip).try(:downcase)
      number_value = row[2].try(:strip).try(:downcase)
      title = row[4].try(:strip)

      if title.blank?
        title = row[3].try(:strip)
      end

      teaser = row[5].try(:strip)
      description = row[6].try(:strip)
      grade = row[7].try(:strip).try(:downcase)

      short_title = if level == 'module'
        'core proficiencies'
      elsif level == 'lesson'
        "part #{number_value}".strip
      else
        "#{level} #{number_value}".strip
      end
      grades = grade.split(',').map(&:strip).map { |str| "grade #{str}" }

      res = Resource.create(
        title: title,
        teaser: teaser,
        description: description,
        short_title: short_title,
        grade_list: grades,
        subject: 'ela',
        time_to_teach: 60
      )

      puts "#{res.id} - #{res.title}"

      res
    end

    state = nil
    grade_cur = nil
    module_cur = nil
    unit_cur = nil

    require 'set'
    grade_curs = Set.new

    file = ENV['CSV_FILE']

    Resource.transaction do
      CSV.readlines(file).each_with_index do |row,i|
        level = row[1].strip.downcase
        state = if level == 'module'
                  :module
                elsif level == 'unit'
                  :unit
                elsif level == 'lesson'
                  :lesson
                else
                  puts level
                  raise StandardError.new('level probl')
                end

        resource = parse_resource_from_row(row)

        if state == :module
          grade_cur = Curriculum
            .grades
            .where_grade(resource.grades.first.name)
            .where_subject(:ela)
            .where(parent_id: nil, seed_id: nil)
            .first

          grade_curs.add(grade_cur.id.to_i)

          module_cur = Curriculum.create(
            item: resource,
            curriculum_type: CurriculumType.module
          )
          puts "Module #{module_cur.id}"
          grade_cur.add_child(module_cur)

        elsif state == :unit
          unit_cur = Curriculum.create(
            item: resource,
            curriculum_type: CurriculumType.unit
          )
          puts "Unit #{unit_cur.id}"
          module_cur.add_child(unit_cur)

        elsif state == :lesson
          unit_cur.add_child(resource)
        end
      end

      grade_curs.each do |id|
        cur = Curriculum.find(id)
        puts "Updating trees for cur. #{cur.resource.title}"
        cur.update_trees
      end
    end
  end

  task import_prek_k_1_2: [:environment] do
    state = nil
    curriculum = nil
    
    Resource.transaction do
      CSV.foreach(ENV['CSV_FILE']) do |csv|
        if csv[0].present?
          state = :unit
        else
          state = :lesson
        end

        if state == :unit
          if !curriculum.nil?
            curriculum.reload
            curriculum.update_trees
          end

          res = Resource.find(csv[0])
          res.title = csv[3].try(:strip)
          res.teaser = csv[4].try(:strip)
          res.description = csv[5].try(:strip)
          res.save!

          curriculums = res.curriculums.where(parent_id: nil, seed_id: nil)

          if curriculums.size > 1
            byebug
            raise StandardError.new('More than one curriculum') 
          end
          raise StandardError.new('No curriculums') if curriculums.empty?

          curriculum = curriculums.first
        elsif state == :lesson
          res = Resource.new
          res.title = csv[3].try(:strip)
          res.teaser = csv[4].try(:strip)
          res.description = csv[5].try(:strip)
          res.subject = curriculum.resource.subject
          res.time_to_teach = 60
          lesson_num = csv[2].downcase.match(/lesson (?<l>\d+)/)[1]
          raise StandardError.new('Couldnt find lesson num') unless lesson_num
          res.short_title = "lesson #{lesson_num}"
          puts res.short_title
          res.save!

          curriculum.children.create!(
            item_id: res.id,
            item_type: 'Resource',
            curriculum_type: CurriculumType.lesson,
            position: curriculum.reload.children.size
          )
        end
      end
    end
  end

  task attach_files: [:environment] do
    class IntendedAttachment
      attr_reader :path

      def initialize(row)
        @path = row.strip
      end
      
      def split_path
        @split_path ||= path.split('/')
      end
      
      def grade
        split_path[0].strip
      end

      def mod
        split_path[1].strip
      end

      def mod_level?
        split_path.size == 3
      end
        
      def unit
        split_path[2].strip
      end

      def unit_level?
        split_path.size == 4
      end

      def lesson
        split_path[3].strip
      end

      def lesson_level?
        split_path.size == 5
      end

      def unit_num
        match = unit.downcase.match(/unit (?<l>\d+)/)
        match[1] if match
      end

      def lesson_num
        return unless lesson_level?
        match = lesson.downcase.match(/lesson (?<l>\d+)/)
        match[1] if match
      end

      def grade_material?
        return false unless mod_level?
        !mod.downcase.index('grade').nil?
      end

      def mod_material?
        return unless unit_level?
        !unit.downcase.index('module').nil?
      end

      def unit_material?
        return unless lesson_level?
        !lesson.downcase.index('unit').nil?
      end

      def lesson_material?
        return unless lesson_level?
        lesson_num.present?
      end

      def reconstructed_path
        "#{grade}/#{mod}/#{unit}/#{lesson}"
      end

      def grade_curriculum
        Curriculum.grades.where_grade(grade.downcase).where_subject(:ela).where(parent: nil).first
      end

      def mod_curriculum
        if mod.downcase =~ /skills strand/
          mod_type = :skills
        elsif mod.downcase =~ /listening and learning/
          mod_type = :ll
        end
        grade_curriculum.children.select do |c|
          if mod.downcase =~ /skills strand/
            c.resource.title.downcase =~ /skills strand/
          elsif mod.downcase =~ /listening and learning/
            c.resource.title.downcase =~ /listening and learning/
          end
        end.map { |c| c.item }[0]
      end

      def unit_curriculum
        unit_short_title = "unit #{unit_num}"
        mod_curriculum.children.select do |c|
          c.resource.short_title =~ /^#{unit_short_title}$/
        end.map { |c| c.item }[0]
      end

      def lesson_curriculum
        lesson_short_title = "lesson #{lesson_num}"
        unit_curriculum.children.select do |c|
          c.resource.short_title =~ /^#{lesson_short_title}$/
        end[0]
      end

      def describe
        puts path
        if grade_material?
          puts ". it's grade stuff"
        elsif mod_material?
          puts ". it's module stuff"
        elsif unit_material?
          puts ". it's unit stuff"
        elsif lesson_material?
          puts ". it's lesson stuff"
        end
      end

      def curriculum
        @curriculum ||= begin
          if grade_material?
            grade_curriculum
          elsif mod_material?
            mod_curriculum
          elsif unit_material?
            unit_curriculum
          elsif lesson_material?
            lesson_curriculum
          end
        end
      end
    end

    File.readlines('all_files').each do |line|
      intended = IntendedAttachment.new(line)
      res = intended.curriculum.try(:resource)

      basepath = '/home/saksida/Dropbox_COPY/ELA Grades PreK, K, 1, 2 CKLA'
      realpath = File.join(basepath, intended.path)

      to_upload = File.open(realpath.to_s)

      if res
        uploaded = res.downloads.create!(
          file: to_upload,
          filesize: to_upload.size,
          content_type: Mime::Type.lookup_by_extension(File.extname(basepath).split('.').last),
          title: File.basename(realpath)
        )

        puts "Uploaded #{realpath} to #{res.title}."
        puts uploaded.file.url
      end
    end
  end

  task build_attachment_list: [:environment] do
    class IntendedAttachment
      attr_reader :path

      def initialize(row)
        @path = row.strip
      end
      
      def split_path
        @split_path ||= path.split('/')
      end
      
      def grade
        split_path[0].strip
      end
        
      def unit
        split_path[1].strip
      end

      def unit_num
        match = unit.downcase.match(/unit (?<l>\d+[a-z]?)/)
        match[1] if match
      end

      def reconstructed_path
        "#{grade}/core proficiencies/#{unit}"
      end

      def grade_curriculum
        Curriculum.grades.where_grade(grade.downcase).where_subject(:ela).where(parent: nil).first
      end

      def mod_curriculum
        grade_curriculum.children.select do |c|
          c.resource.title.downcase =~ /core proficiencies/
        end.map { |c| c.item }[0]
      end

      def unit_curriculum
        unit_short_title = "unit #{unit_num}"
        mod_curriculum.children.select do |c|
          c.resource.short_title =~ /^#{unit_short_title}$/
        end.map { |c| c.item }[0]
      end

      def curriculum
        unit_curriculum
      end
    end

    CSV.open('to_attach.csv', 'wb') do |csv|
      File.readlines('all_files.list').each do |line|
        line = line.strip
        intended = IntendedAttachment.new(line)
        puts '-----'
        puts line
        puts intended.unit_num
        puts intended.curriculum.resource.title
        puts '-----'
        res = intended.curriculum.try(:resource)
        csv << [res.id, line, res.first_tree.breadcrumb_title, res.title] if res
      end
    end
  end
end
