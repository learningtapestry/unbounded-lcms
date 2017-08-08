# frozen_string_literal: true

require 'google/apis/drive_v3'

module DocumentDownloader
  class GDoc
    GOOGLE_DRAWING_RE = %r{https?://docs\.google\.com/drawings/[^"]*}i
    GDRIVE_FOLDER_RE = %r{/drive/(.*/)?folders/([^\/]+)/?}

    def initialize(credentials, file_url, klass)
      @credentials = credentials
      @file_url = file_url
      @klass = klass
    end

    def content
      html = service
               .export_file(file_id, 'text/html')
               .encode('ASCII-8BIT')
               .force_encoding('UTF-8')

      # Replaces all google drawings by their Base64 encoded values
      handle_drawings html
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

    def self.list_files(folder_url, google_credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = google_credentials

      files = []
      folder_url.match(GDRIVE_FOLDER_RE) { |m| files.concat list_files_iter(m[2], service) }
      files.map { |f| "https://docs.google.com/document/d/#{f.id}" }
    end

    def self.list_files_iter(folder_id, service)
      files = []
      page_token = nil
      loop do
        result = service.list_files(q: "'#{folder_id}' in parents",
                                    fields: 'files(id, mime_type), nextPageToken',
                                    page_token: page_token)

        result.files.each do |f|
          case f.mime_type
          when 'application/vnd.google-apps.document' then files << f
          when 'application/vnd.google-apps.folder' then files.concat list_files_iter(f.id, service)
          end
        end

        page_token = result.next_page_token
        break if page_token.nil?
      end
      files.flatten
    end

    private

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
