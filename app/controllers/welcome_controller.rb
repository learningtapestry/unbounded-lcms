class WelcomeController < ApplicationController
  def index
    @tweet = TweetPresenter.new(TwitterChannel.latest_tweet)
    @post = WPPostPresenter.new(WPBlog.latest_post)
  end
end
