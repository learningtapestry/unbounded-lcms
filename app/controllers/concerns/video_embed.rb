module VideoEmbed
  extend ActiveSupport::Concern

  included do
    def self.video_id(url)
      return Rack::Utils.parse_query(URI(url).query)['v'] if /youtube/ =~ url
      if result = url.match(/https?:\/\/(www\.)?vimeo.com\/(\d+)/)
        return result[2]
      end
      if result = url.match(/https?:\/\/(www\.)?youtu\.be\/([^"\&\?\/]+)/)
        return result[2]
      end
    end
  end

  def video_id(url)
    self.class.video_id(url)
  end
end
