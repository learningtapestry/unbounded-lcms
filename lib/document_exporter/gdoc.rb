require 'google/apis/drive_v3'

module DocumentExporter
  class Gdoc
    def self.url_for(file_id)
      "https://drive.google.com/open?id=#{file_id}"
    end

    def initialize(credentials)
      @credentials = credentials
    end

    def export(name, content)
      metadata = Google::Apis::DriveV3::File.new(
        name: name,
        mime_type: 'application/vnd.google-apps.document'
      )
      params = {
        content_type: 'text/html',
        upload_source: StringIO.new(content)
      }
      @id = service
              .create_file(metadata, params)
              .id
      self
    end

    def url
      self.class.url_for @id
    end

    private

    def service
      return @_service if @_service.present?
      @_service = Google::Apis::DriveV3::DriveService.new
      @_service.authorization = @credentials
      @_service
    end
  end
end
