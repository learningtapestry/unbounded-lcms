class ContentGuidesController < ApplicationController
  def show
    permalink = params[:permalink]
    content_guide = ContentGuide.find_by_permalink(permalink) || ContentGuide.find(permalink)

    respond_to do |format|
      format.html do
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
    def render_pdf
      cover_image_url =
        if (path = @content_guide.big_photo.url)
          "url(#{request.protocol}#{request.host_with_port}#{path})"
        else
          'none'
        end

      render pdf: @content_guide.name,
             cover: render_to_string(partial: 'cover', locals: { content_guide: @content_guide, cover_image_url: cover_image_url }),
             disposition: 'attachment',
             footer: {
               right: "[#{t('.page')}]"
             },
             header: {
               left: @content_guide.name,
               spacing: 5
             },
             margin: {
               top: 15
             }
    end
end
