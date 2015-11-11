require 'csv'
require 'content/models'

module Content
  module Importers
    class EasolImporter
      include Content::Models

      HEADERS = %w(id url publisher title description grade resource_type standard subject)

      def self.import_csv(filename, replace: false)
        CSV.foreach(filename, headers: true).with_index do |row, i|
          puts "Importing row #{i}."
          
          if replace
            next unless row['id'].present?
            builder = LobjectBuilder.new(Lobject.find(row['id']))
          else
            next unless row['url'].present?
            next if Url.find_by(url: row['url'])
            builder = LobjectBuilder.new
          end

          raise StandardError, "Fields should be: #{fields}" unless row.headers == HEADERS

          Lobject.transaction do
            if (description = row['description']).present?
              builder.clear_descriptions
              builder.add_description(description.strip)
            end

            if (grades = row['grade']).present?
              builder.clear_grades
              grades.split(',').each do |grade|
                builder.add_grade(Grade.normalize_grade(grade))
              end
            end

            if (publishers = row['publisher']).present?
              builder.clear_identities
              publishers.split(',').each do |publisher|
                builder.add_publisher(publisher.strip)
              end
            end

            if (resource_types = row['resource_type']).present?
              builder.clear_resource_types
              resource_types.split(',').each do |resource_type|
                builder.add_resource_type(ResourceType.normalize_name(resource_type))
              end
            end

            if (alignments = row['standard']).present?
              builder.clear_alignments
              alignments.split(',').each do |alignment|
                builder.add_alignment(alignment.strip)
              end
            end

            if (subjects = row['subject']).present?
              builder.clear_subjects
              subjects.split(',').each do |subject|
                builder.add_subject(Subject.normalize_name(subject))
              end
            end

            if (title = row['title']).present?
              builder.clear_titles
              builder.add_title(title.strip)
            end

            if (url = row['url']).present?
              builder.clear_urls
              builder.add_url(url.strip)
            end

            builder.save!
          end
        end

        nil
      end
    end
  end
end
