class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Error::ResourceNotFound, with: :rescue_not_found

  # Raise tranlation missing errors in controllers too
  def t(key, options = {})
    options[:raise] = true
    translate(key, options)
  end

  protected

  def rescue_not_found(err)
    # TODO: log err.message to somewhere
    render template: "errors/show", status: 404
  end

end
