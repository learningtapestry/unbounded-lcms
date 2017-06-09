module DocumentExporter
  class PDF
    def initialize(lesson_document)
      @lesson_document = LessonDocumentPresenter.new lesson_document
    end

    def export
      content = render_template 'show', layout: 'cg_pdf'
      WickedPdf.new.pdf_from_string(content, pdf_params)
    end

    private

    def pdf_params
      xsl = Rails.root.join 'app', 'views', 'lesson_documents', 'pdf', "_toc--#{@lesson_document.subject}.xsl"
      {
        cover: render_template('_cover'),
        disable_internal_links: false,
        disable_external_links: false,
        disposition: 'attachment',
        footer: {
          content: render_template('_footer'),
          line: false,
          spacing: 2
        },
        javascript_delay: 5000,
        header: {
          content: render_template('_header'),
          line: false,
          spacing: 2
        },
        margin: {
          bottom: 18,
          left: 8,
          right: 8,
          top: 18
        },
        outline: { outline_depth: 3 },
        page_size: 'Letter',
        print_media_type: false,
        toc: {
          disable_dotted_lines: true,
          disable_links: false,
          disable_toc_links: false,
          disable_back_links: false,
          xsl_style_sheet: xsl
        }
      }
    end

    def render_template(name, layout: 'cg_plain_pdf')
      # Using backport of Rails 5 Renderer here
      ApplicationController.render(
        template: File.join('lesson_documents', 'pdf', name),
        layout: layout,
        locals: { lesson_document: @lesson_document }
      )
    end
  end
end
