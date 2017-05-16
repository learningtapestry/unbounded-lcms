require 'google/apis/drive_v3'

module DocumentDownloader
  class FileNotFound < StandardError; end

  class GDoc
    def initialize(credentials, file_url, klass)
      @credentials = credentials
      @file_url = file_url
      @klass = klass
    end

    def file
      @_file ||= service.get_file(
        file_id, fields: 'lastModifyingUser,modifiedTime,name,version'
      )
    end

    def content
      @_content ||= service.export_file(
        file_id, 'text/html'
      ).encode('ASCII-8BIT').force_encoding('UTF-8')
    end

    def import
      document = @klass.find_or_initialize_by(file_id: file_id)
      document.attributes = {
        name: file.name,
        last_modified_at: file.modified_time,
        last_author_email: file.last_modifying_user.try(:email_address),
        last_author_name: file.last_modifying_user.try(:display_name),
        original_content: content,
        version: file.version
      }
      document.save
      document
    end

    private

    def service
      return @_service if @_service.present?
      @_service = Google::Apis::DriveV3::DriveService.new
      @_service.authorization = @credentials
      @_service
    end

    def file_id
      @_file_id ||= @file_url.scan(/\/d\/([^\/]+)\/?/).first.first
    end
  end
end
