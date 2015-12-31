require 'csv'

require 'content/models'

module Content
  module Exporters
    class CsvExporter
      include Content::Models

      HEADERS = ['ID Unbounded Database', 'ID Our Database', 'Title', 'Subtitle', 'Description', 'URL', 'Grades', 'Standards', 'Resource Types', 'Subjects']
      HOST    = 'https://content-staging.learningtapestry.com'

      def initialize(grade_ids)
        @grades = Grade.where(id: grade_ids).order(:grade)
      end

      def export
        lobjects = Lobject.select('DISTINCT lobjects.*').
                           includes(:alignments, :documents, :grades, :lobject_descriptions, :lobject_titles, :resource_types, :subjects)

        if @grades.any?
          lobjects = lobjects.where(lobject_grades: { grade_id: @grades.map(&:id) })
        end

        csv = CSV.generate do |csv|
          csv << HEADERS

          lobjects.find_each do |lobject|
            csv << [
              lobject.documents.first.try(:source_document_id),
              lobject.id,
              lobject.title,
              lobject.subtitle,
              lobject.description,
              "#{HOST}/resources/#{lobject.id}",
              lobject.grades.map(&:grade).join(', '),
              lobject.alignments.map(&:name).join(', '),
              lobject.resource_types.map(&:name).join(', '),
              lobject.subjects.map(&:name).join(', ')
            ]
          end
        end

        csv
      end

      def filename
        name = ['unbounded_resources']
        name += @grades.map(&:grade).map { |g| g.gsub(' ', '-') }
        name.join('_') + '.csv'
      end
    end
  end
end
