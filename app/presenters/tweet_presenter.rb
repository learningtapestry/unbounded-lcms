class TweetPresenter < SimpleDelegator
  TWITTER_URL = 'https://twitter.com'.freeze
  TWITTER_USER = ENV['UB_TWITTER_CHANNEL']

  def render
    msg = full_text
    msg = msg.gsub(/#\w+/) { |t| to_hashtag(t) }
    msg = msg.gsub(/@\w+/) { |u| to_user(u) }
    h.auto_link(msg)
  end

  def user_link
    to_user(TWITTER_USER, 'o-twitter__user')
  end

  def user_url
    "#{TWITTER_URL}/#{TWITTER_USER}"
  end

  private

  def h
    ApplicationController.helpers
  end

  def to_hashtag(t)
    h.link_to t, "#{TWITTER_URL}/hashtag/#{t[1..-1]}"
  end

  def to_user(u, cls = '')
    h.link_to u, "#{TWITTER_URL}/#{u}", class: cls
  end
end
