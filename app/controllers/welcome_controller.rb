class WelcomeController < ApplicationController
  # the react_component SubscriptionPopup is having issues with csrf_token and
  # remove_session middleware, so we are temporarily disabling for this action
  skip_before_filter :verify_authenticity_token, only: :subscription

  def index
  end

  def subscription
    cookies.delete(:unbounded_subscription) unless Subscription.create(subscription_params)
    redirect_to root_path
  end

  private

  def subscription_params
    params.require(:subscription).permit(:name, :email)
  end
end
