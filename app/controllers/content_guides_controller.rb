class ContentGuidesController < ApplicationController
  def show
    content_guide = ContentGuide.find(params[:id])

    respond_to do |format|
      format.html do
        @content_guide = ContentGuidePresenter.new(content_guide, request.base_url, view_context)
      end

      format.pdf do
        @content_guide = ContentGuidePdfPresenter.new(content_guide, request.base_url, view_context)

        render pdf: @content_guide.name,
               disposition: 'attachment',
               margin: {
                 top: 15
               },
               header: {
                 left: @content_guide.name,
                 spacing: 5
               },
               footer: {
                 right: '[page]'
               }
      end
    end
  end
end
