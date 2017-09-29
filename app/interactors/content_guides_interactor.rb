# frozen_string_literal: true

class ContentGuidesInteractor < BaseInteractor
  attr_reader :props

  def run; end

  def presenter
    @presenter ||= begin
      presenter_class = context.action_name =~ /pdf/ ? ContentGuidePdfPresenter : ContentGuidePresenter
      presenter_class.new(
        content_guide,
        context.request.base_url,
        context.view_context,
        wrap_keywords: true
      )
    end
  end

  def debug?
    params.key?('debug') || params.key?('nocache')
  end

  def pdf_params
    {
      pdf: presenter.pdf_title,
      cover: cover,
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
      footer: {
        html: {
          template: 'content_guides/_footer_pdf',
          layout: 'cg_plain_pdf',
          locals:  { title: presenter.footer_title }
        },
        line: false
      },
      toc: {
        disable_dotted_lines: true,
        disable_links: false,
        disable_toc_links: false,
        disable_back_links: false,
        xsl_style_sheet: Rails.root.join('app', 'views', 'content_guides', "_toc--#{presenter.subject}.xsl")
      }
    }
  end

  def content_guide
    @content_guide ||= ContentGuide.find_by_permalink(params[:id]) || ContentGuide.find(params[:id])
  end

  private

  def cover
    context.render_to_string(
      template: 'content_guides/_cover_pdf',
      layout: 'cg_plain_pdf',
      locals: { content_guide: presenter, cover_image_url: cover_image_url }
    )
  end

  def cover_image_url
    path = content_guide.big_photo.url
    if path && path.start_with?('http')
      "url(#{path})"
    elsif path.present?
      req = context.request
      "url(#{req.protocol}#{req.host_with_port}#{path})"
    else
      'none'
    end
  end
end
