# frozen_string_literal: true

module DocumentDownloader
  class Gdoc < DocumentDownloader::Base
    MIME_TYPE = 'application/vnd.google-apps.document'
    GOOGLE_DRAWING_RE = %r{https?://docs\.google\.com/?[^"]*/drawings/[^"]*}i

    def self.gdoc_file_url(id)
      "https://docs.google.com/document/d/#{id}"
    end

    def download
      html = service
               .export_file(file_id, 'text/html')
               .encode('ASCII-8BIT')
               .force_encoding('UTF-8')
      @content = handle_google_drawings(html)
      self
    end

    private

    def handle_google_drawings(html)
      return html unless (match = html.scan(GOOGLE_DRAWING_RE))

      headers = { 'Authorization' => "Bearer #{@credentials.access_token}" }

      match.to_a.uniq.each do |url|
        response = HTTParty.get CGI.unescapeHTML(url), headers: headers
        new_src = "data:#{response.content_type};base64, #{Base64.encode64(response)}\" drawing_url=\"#{url}"
        html = html.gsub(url, new_src)
      end

      html
    end
  end
end
