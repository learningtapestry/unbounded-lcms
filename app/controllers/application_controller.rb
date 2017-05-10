class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # require auth for acessing the pilot
  http_basic_authenticate_with name: ENV['HTTP_AUTH_NAME'], password: ENV['HTTP_AUTH_PASS'] if Rails.env.production?

  rescue_from ActiveRecord::RecordNotFound do
    render 'pages/not_found', status: :not_found
  end

  # Raise tranlation missing errors in controllers too
  def t(key, options = {})
    options[:raise] = true
    translate(key, options)
  end
end
