class ContentGuidesController < ApplicationController
  include AnalyticsTracking
  before_action :find_content_guide

  def show
    @content_guide = ContentGuidePresenter.new(
      @content_guide_model,
      request.base_url,
      view_context,
      wrap_keywords: true
    )
  end

  def show_pdf
    @content_guide = ContentGuidePdfPresenter.new(
      @content_guide_model,
      request.base_url,
      view_context,
      wrap_keywords: true
    )
      
    track_download(
      action: content_guide_path(
        @content_guide_model.permalink_or_id,
        @content_guide_model.slug
      ),
      label: ''
    )
  
    render_pdf
  end

  protected
    def find_content_guide
      @content_guide_model = ContentGuide.find_by_permalink(params[:id]) || ContentGuide.find(params[:id])
    end

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
             cover: render_to_string(template: 'content_guides/_cover_pdf',
                                     layout: 'cg_plain_pdf',
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
