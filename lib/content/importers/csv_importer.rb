require 'csv'
require 'json'

require 'content/models'

module Content
  module Importers
    class CsvImporter
      include Content::Models

      HEADERS = %w(id url publisher title description grade resource_type standard subject)

      class Exporter
        include Content::Models
        include Enumerable

        def each
          yield header
          
          generate_csv do |row|
            yield row
          end
        end

        def header
          CSV.generate_line(HEADERS).to_s
        end

        def generate_csv
          Lobject.find_each do |lobject|
            yield CSV.generate_line([
              lobject.id,
              lobject.url.url,
              lobject.lobject_identities
                .select { |id| id.identity_type == 'publisher' }
                .map(&:identity)
                .map(&:name)
                .join(','),
              lobject.title,
              lobject.description,
              lobject.grades
                .map(&:grade)
                .join(','),
              lobject.resource_types
                .map(&:name)
                .join(','),
              lobject.alignments
                .map(&:name)
                .join(','),
              lobject.subjects
                .map(&:name)
                .join(',')             
            ]).to_s
          end
        end
      end

      def self.check_csv(filename)
        File.open(filename) do |f|
          CSV.parse(f.readline).first.to_a == HEADERS
        end
      rescue
        false
      end

      def self.import(filename, replace: false)
        CSV.foreach(filename, headers: true).with_index do |row, i|
          if i == 0 && row.headers != HEADERS
            raise ArgumentError, "Fields should be: #{HEADERS} but are #{row.headers}"
          end

          puts "Importing row #{i}."
          
          if replace
            next unless row['id'].present?
            builder = LobjectBuilder.new(Lobject.find(row['id']))
          else
            next unless row['url'].present?
            next if Url.find_by(url: row['url'])
            builder = LobjectBuilder.new
          end

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
