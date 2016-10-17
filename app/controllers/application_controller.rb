class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound do
    render 'pages/not_found', status: :not_found
  end

  # Raise tranlation missing errors in controllers too
  def t(key, options = {})
    options[:raise] = true
    translate(key, options)
  end
end
