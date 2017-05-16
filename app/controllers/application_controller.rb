class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # require auth for acessing the pilot
  before_action :pilot_authentication if Rails.env.production?

  rescue_from ActiveRecord::RecordNotFound do
    render 'pages/not_found', status: :not_found
  end

  # Raise tranlation missing errors in controllers too
  def t(key, options = {})
    options[:raise] = true
    translate(key, options)
  end

  protected

  def pilot_authentication
    return unless request.format.html?

    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username ==  ENV['HTTP_AUTH_NAME'] && password == ENV['HTTP_AUTH_PASS']
    end
  end
end
