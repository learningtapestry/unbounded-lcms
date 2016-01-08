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
        child_ids_rel = LobjectCollection.curriculum_maps.select('DISTINCT lobject_children.child_id').joins(:lobject_children)
        root_ids_rel  = LobjectCollection.curriculum_maps.select(:lobject_id)

        lobjects = Lobject.select('DISTINCT lobjects.*').
                           where('(lobjects.id IN (:root_ids)) OR (lobjects.id IN (:child_ids))', child_ids: child_ids_rel, root_ids: root_ids_rel).
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
              text_description(lobject.description),
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

      private

      def text_description(description)
        doc = Nokogiri::HTML(description)
        doc.xpath('//p/text()').text
      rescue
        nil
      end
    end
  end
end
