class CurriculumExporter
  HEADERS = ['ID Our Database', 'Title', 'Subtitle', 'Description', 'URL', 'Grades', 'Standards', 'Resource Types', 'Subjects']
  HOST    = 'https://content-staging.learningtapestry.com'

  def initialize(grade_ids = [])
    @grades = Grade.where(id: grade_ids).order(:grade)
  end

  def export
    collections_rel = ResourceCollection.curriculum_maps.
                                        joins(resource: :resource_grades).
                                        where(resource_grades: { grade_id: @grades.map(&:id) })

    child_ids_rel = collections_rel.select('DISTINCT resource_children.child_id').joins(:resource_children)
    root_ids_rel  = collections_rel.select(:resource_id)

    resources = Resource.select('DISTINCT resources.*').
                       where('(resources.id IN (:root_ids)) OR (resources.id IN (:child_ids))', child_ids: child_ids_rel, root_ids: root_ids_rel).
                       includes(:standards, :grades, :resource_types, :subjects)

    package = Axlsx::Package.new
    package.workbook.add_worksheet(name: 'Resources') do |sheet|
      sheet.add_row(HEADERS)
      
      resources.find_each do |resource|
        sheet.add_row([
          resource.id,
          resource.title,
          resource.subtitle,
          resource.text_description,
          "#{HOST}/resources/#{resource.id}",
          resource.grades.map(&:grade).join(', '),
          resource.standards.map(&:name).join(', '),
          resource.resource_types.map(&:name).join(', '),
          resource.subjects.map(&:name).join(', ')
        ])
      end
    end

    stream = StringIO.new
    stream.write(package.to_stream.read)
    stream.string
  end

  def filename
    name = ['unbounded_curriculum']
    name += @grades.map(&:grade).map { |g| g.gsub(' ', '-') }
    name.join('_') + '.xlsx'
  end
end
