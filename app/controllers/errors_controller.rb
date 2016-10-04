class ErrorsController < ApplicationController

  def show
    @delayed_redirection_url = search_url # Or set to nil
    render status: params[:code].to_i
  end

end
