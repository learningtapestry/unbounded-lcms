class WelcomeController < ApplicationController
  def index
    @tweet = TweetPresenter.new(TwitterChannel.latest_tweet)
  end
end
