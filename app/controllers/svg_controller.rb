class SVGController < ApplicationController
  def show
    @resource = Resource.find params[:resource_id]
    render html: GenerateSVGThumbnailService.new(@resource).run.html_safe
  end
end
