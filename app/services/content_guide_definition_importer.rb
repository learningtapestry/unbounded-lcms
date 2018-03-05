# frozen_string_literal: true

class ContentGuideDefinitionImporter
  def self.call(credentials, file_id)
    service = Google::Apis::DriveV3::DriveService.new
    service.authorization = credentials
    content = service.export_file(file_id, 'text/csv')

    ContentGuideDefinition.transaction do
      ContentGuideDefinition.delete_all
      CSV.parse(content) do |row|
        ContentGuideDefinition.create keyword: row[0], description: row[1]
      end
    end
  end
end
