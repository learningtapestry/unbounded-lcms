require 'csv'
require 'json'

require 'content/models'

module Content
  module Importers
    class CsvImporter
      class << self
        def import_lr(csv_data)
          csv_data.each do |row|
            if lr_doc = Models::LrDocument.find_by(doc_id: row[0])
              next
            else
              lr_doc = Models::LrDocument.new(
                doc_id: row[0],
                active: row[1],
                doc_type: row[2],
                doc_version: row[3],
                payload_placement: row[4],
                resource_data_type: row[5],
                resource_locator: row[6],
                raw_data: JSON.parse(row[7]),
                created_at: row[8],
                updated_at: row[9],
                resource_data_json: JSON.parse(row[10]),
                resource_data_xml: row[11],
                resource_data_string: row[12],
                identity: JSON.parse(row[13]),
                keys: JSON.parse(row[14]),
                payload_schema: JSON.parse(row[15]),
                format_parsed_at: row[16],
                source_document: Models::SourceDocument.new(source_type: Models::SourceDocument.source_types[:lr])
              )

              lr_doc.save!
            end
          end
        end

        def import_csv(filename, csv_format)
          csv_data = CSV.parse(File.read(filename))
          if csv_format.to_sym == :lr
            import_lr(csv_data)
          end
        end
      end
    end
  end
end
