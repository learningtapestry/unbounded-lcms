class TwitterChannel
  TWITTER_CACHE_TIMEOUT = ENV.fetch('UB_TWITTER_CACHE_TIMEOUT', 1800)
  TWITTER_CHANNEL = ENV['UB_TWITTER_CHANNEL']

  def self.latest_tweet
    return unless TWITTER_CHANNEL.present?
    Rails.cache.fetch("tweets:#{TWITTER_CHANNEL}", expires_in: TWITTER_CACHE_TIMEOUT) do
      twitter.user_timeline(TWITTER_CHANNEL, count: 1).try(:first)
    end
  rescue Twitter::Error => e
    Rails.logger.error("Error requesting twitter: #{e.code}, #{e.message}")
  end

  private

  def self.twitter
    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['UB_TWITTER_API_KEY']
      config.consumer_secret = ENV['UB_TWITTER_API_SECRET']
      config.access_token = ENV['UB_TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['UB_TWITTER_ACCESS_TOKEN_SECRET']
    end
  end
end
