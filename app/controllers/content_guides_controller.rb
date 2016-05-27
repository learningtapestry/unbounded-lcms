class ContentGuidesController < ApplicationController
  def show
    content_guide = ContentGuide.find(params[:id])

    respond_to do |format|
      format.html do
        @content_guide = ContentGuidePresenter.new(
          content_guide,
          request.base_url,
          view_context,
          wrap_keywords: true
        )
      end
      # else
      #   format.html do
      #     @content_guide = ContentGuidePdfPresenter.new(
      #       content_guide,
      #       request.base_url,
      #       view_context
      #     )
      #     render 'show.pdf', layout: 'pdf'
      #   end
      # end

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
             show_as_html: params.key?('debug'),
             page_size: 'Letter',
             disable_internal_links: false,
             disable_external_links: false,
             layout: 'pdf.html',
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
