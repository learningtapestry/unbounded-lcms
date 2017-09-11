class WPBlog
  WP_CACHE_TIMEOUT = ENV.fetch('UB_WP_CACHE_TIMEOUT', 1800)
  WP_BLOG = ENV['UB_WP_BLOG']
  WP_API_URL = "#{WP_BLOG}/wp-json/wp/v2/posts?per_page=1&_embed".freeze

  def self.latest_post
    return unless WP_BLOG.present?
    Rails.cache.fetch("wp_blog:#{ERB::Util.html_escape(WP_BLOG)}", expires_in: WP_CACHE_TIMEOUT) do
      Oj.load(RestClient.get(WP_API_URL)).try(:first)
    end
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("Error requesting #{WP_BLOG}: #{e.code}, #{e.message}")
    render text: e.response, status: '404'
  end
end
