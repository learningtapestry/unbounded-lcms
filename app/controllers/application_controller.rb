class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Raise tranlation missing errors in controllers too
  def t(key, options = {})
    options[:raise] = true
    translate(key, options)
  end
end
