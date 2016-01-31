require 'content/models'

module Content
  module Exporters
    class CurriculumExporter
      include Content::Models

      HEADERS = ['ID Unbounded Database', 'ID Our Database', 'Title', 'Subtitle', 'Description', 'URL', 'Grades', 'Standards', 'Resource Types', 'Subjects']
      HOST    = 'https://content-staging.learningtapestry.com'

      def initialize(grade_ids = [])
        @grades = Grade.where(id: grade_ids).order(:grade)
      end

      def export
        collections_rel = LobjectCollection.curriculum_maps.
                                            joins(lobject: :lobject_grades).
                                            where(lobject_grades: { grade_id: @grades.map(&:id) })

        child_ids_rel = collections_rel.select('DISTINCT lobject_children.child_id').joins(:lobject_children)
        root_ids_rel  = collections_rel.select(:lobject_id)

        lobjects = Lobject.select('DISTINCT lobjects.*').
                           where('(lobjects.id IN (:root_ids)) OR (lobjects.id IN (:child_ids))', child_ids: child_ids_rel, root_ids: root_ids_rel).
                           includes(:alignments, :documents, :grades, :lobject_descriptions, :lobject_titles, :resource_types, :subjects)

        package = Axlsx::Package.new
        package.workbook.add_worksheet(name: 'Resources') do |sheet|
          sheet.add_row(HEADERS)
          
          lobjects.find_each do |lobject|
            sheet.add_row([
              lobject.documents.first.try(:source_document_id),
              lobject.id,
              lobject.title,
              lobject.subtitle,
              lobject.text_description,
              "#{HOST}/resources/#{lobject.id}",
              lobject.grades.map(&:grade).join(', '),
              lobject.alignments.map(&:name).join(', '),
              lobject.resource_types.map(&:name).join(', '),
              lobject.subjects.map(&:name).join(', ')
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
  end
end
