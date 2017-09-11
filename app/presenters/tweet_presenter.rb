class TweetPresenter < SimpleDelegator
  TWITTER_URL = 'https://twitter.com'.freeze

  def render
    msg = full_text
    msg = msg.gsub(/#\w+/) { |t| to_hashtag(t) }
    msg = msg.gsub(/@\w+/) { |u| to_user(u) }
    h.auto_link(msg)
  end

  def user_url
    to_user("@#{user.screen_name}", 'o-twitter__user')
  end

  private

  def h
    ApplicationController.helpers
  end

  def to_hashtag(t)
    h.link_to t, "#{TWITTER_URL}/hashtag/#{t.slice(0)}"
  end

  def to_user(u, cls = '')
    h.link_to u, "#{TWITTER_URL}/#{u.slice(0)}", class: cls
  end
end
