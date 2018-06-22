# frozen_string_literal: true

#
# Import resources from db/data/v1-exports/*.json files
# see more on: https://github.com/learningtapestry/unbounded/issues/953
#
class ResourcesJsonImporter
  def initialize(slug)
    s, g = slug.split('/')
    @params = OpenStruct.new subject: s, grade: g
  end

  def run
    puts "===> Importing #{source_file}"

    # clear grade descendants
    grade.descendants.destroy_all

    # import new entries
    json['children'].each { |data| create_node data, grade }

    puts "\n"
  end

  private

  GRADE_RE = /grade (\d+)/
  AUTHORS = {
    ela: 'Expeditionary Learning',
    math: 'Great Minds'
  }.freeze

  def create_node(data, parent)
    resource = parent.children.create!(
      author_id: author.id,
      curriculum_type: data['hierarchy_level'],
      level_position: data['position'],
      # parent_id: parent.id,
      resource_type: Resource.resource_types[:resource],
      short_title: data['short_title'],
      teaser: data['teaser'],
      title: data['title'],
      tree: true
    )
    data['standards'].each do |name|
      std = Standard.find_or_create_by!(name: name, subject: @params.subject)
      resource.standards << std
    end
    print '.'
    data['children']&.each { |node| create_node node, resource }
  end

  def author
    @author ||= begin
      name = AUTHORS[@params.subject.to_sym]
      Author.find_or_create_by(name: name) { |a| a.slug = name.parameterize }
    end
  end

  def grade
    @grade ||= Resource.tree
                 .where_subject(@params.subject)
                 .where_grade(@params.grade)
                 .grades.take
  end

  def json
    @json ||= JSON.parse File.read(Rails.root.join source_file)
  end

  def source_file
    grade_ = case @params.grade
             when 'prekindergarten' then 'pk'
             when 'kindergarten' then 'k'
             else "g#{@params.grade.match(GRADE_RE)[1]}"
             end
    "db/data/v1-exports/#{@params.subject}-#{grade_}.json"
  end
end
