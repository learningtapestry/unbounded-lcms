class GoogleDocDefinition < ActiveRecord::Base
  validates :keyword, :description, presence: true
  validates :keyword, uniqueness: true

  class << self
    def import(file_id, credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = credentials
      content = service.export_file(file_id, 'text/csv')

      transaction do
        delete_all
        CSV.parse(content) do |row|
          d = create(keyword: row[0], description: row[1])
          p [:def, d]
        end
      end
    end
  end
end
