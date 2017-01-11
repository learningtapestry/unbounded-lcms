class SVGController < ApplicationController
  def show
    @resource = Resource.find params[:resource_id]
    media = params[:media] || :all
    svg = GenerateSVGThumbnailService.new(@resource, media: media.to_sym).rendered
    render html: svg.html_safe
  end
end
