class SVGController < ApplicationController
  def show
    @resource = Resource.find params[:resource_id]
    render :'shared/social_thumb.svg.erb'
  end
end
