class ContentGuidesController < ApplicationController
  def show
    content_guide = ContentGuide.find_by_permalink(params[:id]) || ContentGuide.find(params[:id])

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
          view_context,
          wrap_keywords: true
        )
        render_pdf
      end
    end
  end

  protected
    def render_pdf
      cover_image_url =
        if (path = @content_guide.big_photo.url) && path.start_with?('http')
          "url(#{path})"
        elsif path.present?
          "url(#{request.protocol}#{request.host_with_port}#{path})"
        else
          'none'
        end

      render pdf: @content_guide.name,
             cover: render_to_string(template: 'content_guides/_cover',
                                     layout: 'cg_plain',
                                     locals: { content_guide: @content_guide,
                                               cover_image_url: cover_image_url
                                             }
                                    ),
             disposition: 'attachment',
             show_as_html: params.key?('debug'),
             page_size: 'Letter',
             outline: { outline_depth: 3 },
             margin: { bottom: 18 },
             disable_internal_links: false,
             disable_external_links: false,
             layout: 'cg',
             print_media_type: false,
             footer: { html: { template: 'content_guides/_footer',
                               layout: 'cg_plain',
                               locals:  { title: @content_guide.footer_title }
                             },
                       line: false
                      },
             toc: { disable_dotted_lines: true,
                    disable_links: false,
                    disable_toc_links: false,
                    disable_back_links: false,
                    xsl_style_sheet: Rails.root.join('app', 'views', 'content_guides', "_toc--#{@content_guide.subject}.xsl")
                  }
    end
end
