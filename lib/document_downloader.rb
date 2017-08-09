require 'google/apis/drive_v3'

module DocumentDownloader
  class GDoc
    GOOGLE_DRAWING_RE = %r{https?://docs\.google\.com/drawings/[^"]*}i

    def initialize(credentials, file_url, klass)
      @credentials = credentials
      @file_url = file_url
      @klass = klass
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

    def content
      html = service
               .export_file(file_id, 'text/html')
               .encode('ASCII-8BIT')
               .force_encoding('UTF-8')

      # Replaces all google drawings by their Base64 encoded values
      handle_drawings html
    end

    def file
      @_file ||= service.get_file(
        file_id, fields: 'lastModifyingUser,modifiedTime,name,version'
      )
    end

    def file_id
      @_file_id ||= begin
        @file_url.scan(%r{/d/([^\/]+)/?}).first.try(:first) ||
        @file_url.scan(%r{/open\?id=([^\/]+)/?}).first.try(:first)
      end
    end

    def handle_drawings(html)
      return html unless (match = html.scan(GOOGLE_DRAWING_RE))

      headers = { 'Authorization' => "Bearer #{@credentials.access_token}" }

      match.to_a.uniq.each do |url|
        response = HTTParty.get CGI.unescapeHTML(url), headers: headers
        new_src = "data:#{response.content_type};base64, #{Base64.encode64(response)}"
        html = html.gsub(url, new_src)
      end

      html
    end

    def service
      return @_service if @_service.present?
      @_service = Google::Apis::DriveV3::DriveService.new
      @_service.authorization = @credentials
      @_service
    end
  end
end
