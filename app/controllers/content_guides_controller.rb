class ContentGuidesController < ApplicationController
  include AnalyticsTracking

  def show
    cg = ContentGuide.find_by_permalink(params[:id]) || ContentGuide.find(params[:id])
    @content_guide = ContentGuidePresenter.new(
      cg,
      request.base_url,
      view_context,
      wrap_keywords: true
    )
  end

  def show_pdf
    cg = ContentGuide.find(params[:id])

    if params.key?('debug') || params.key?('nocache')
      render_pdf(cg)
      return
    end

    if cg.pdf.blank?
      cg.remote_pdf_url = url_for(nocache: '')
      cg.save!
    end

    track_download(
      action: content_guide_path(cg.permalink_or_id, cg.slug),
      label: ''
    )

    redirect_to cg.pdf_url
  end

  protected
    def render_pdf(content_guide)
      @content_guide = ContentGuidePdfPresenter.new(
        content_guide,
        request.base_url,
        view_context,
        wrap_keywords: true
      )

      cover_image_url =
        if (path = @content_guide.big_photo.url) && path.start_with?('http')
          "url(#{path})"
        elsif path.present?
          "url(#{request.protocol}#{request.host_with_port}#{path})"
        else
          'none'
        end

      render pdf: @content_guide.pdf_title,
             cover: render_to_string(template: 'content_guides/_cover_pdf',
                                     layout: 'cg_plain_pdf',
                                     locals: { content_guide: @content_guide,
                                               cover_image_url: cover_image_url }),
             disposition: 'attachment',
             javascript_delay: 5000,
             show_as_html: params.key?('debug'),
             page_size: 'Letter',
             outline: { outline_depth: 3 },
             margin: { bottom: 18, left: 8, right: 8 },
             disable_internal_links: false,
             disable_external_links: false,
             layout: 'cg_pdf',
             print_media_type: false,
             footer: { html: { template: 'content_guides/_footer_pdf',
                               layout: 'cg_plain_pdf',
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
