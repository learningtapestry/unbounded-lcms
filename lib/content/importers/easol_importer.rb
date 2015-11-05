require 'csv'

require 'content/models'

module Content
  module Importers
    class EasolImporter
      include Content::Models

      def self.import_csv(filename)
        csv_data = CSV.parse(File.read(filename))

        csv_data.each_with_index do |row, i|
          puts "Importing row #{i}."
          next unless row[2].present?
          next if Url.find_by(url: row[2])

          builder = LobjectBuilder.new
            .add_publisher(row[0])
            .add_title(row[1])
            .add_url(row[2])
            .set_organization(Organization.easol)

          if row[3].present?
            builder.add_description(row[3])
          end

          if row[4].present?
            row[4].split(',').each do |subject|
              builder.add_subject(Subject.normalize_name(subject))
            end
          end

          if row[5].present?
            row[5].split(',').each do |grade|
              builder.add_grade(Grade.normalize_grade(grade))
            end
          end

          if row[6].present?
            row[6].split(',').each do |standard|
              builder.add_standard(standard.strip)
            end
          end

          if row[7].present?
            row[7].split(',').each do |res|
              builder.add_resource_type(ResourceType.normalize_name(res.strip))
            end
          end

          builder.save!
        end

        nil
      end

      def self.import_lr_csv_to_lobjects(filename)
        CSV.foreach(filename, headers: true).with_index do |row, i|
          puts "Importing row #{i}."
          next if Url.find_by(url: row['url'])

          builder = LobjectBuilder.new
            .add_publisher(row['publisher'])
            .add_title(row['title'])
            .add_url(row['url'])
            .set_organization(Organization.lr)

          if (description = row['description']).present?
            builder.add_description(description)
          end

          if (alignments = row['col_a']).present?
            alignments.split(',').each do |alignment|
              builder.add_alignment(alignment.strip)
            end
          end

          builder.save!
        end

        nil
      end
    end
  end
end
