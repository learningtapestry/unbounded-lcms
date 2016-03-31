class ContentGuidesController < ApplicationController
  def show
    content_guide = ContentGuide.find(params[:id])

    respond_to do |format|
      format.html do
        params_cache_key
        @content_guide = ContentGuidePresenter.new(
          content_guide,
          request.base_url,
          view_context,
          wrap_keywords: true
        )
      end

      format.pdf do
        @content_guide = ContentGuidePdfPresenter.new(
          content_guide,
          request.base_url,
          view_context
        )
        render_pdf
      end
    end
  end

  protected
    def params_cache_key
      @params_cache_key ||= "id::#{params[:id]}"
    end

    def render_pdf
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
