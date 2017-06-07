module DocumentExporter
  class PDF
    def initialize(lesson_document)
      @lesson_document = lesson_document
    end

    def cover_params
      {
        template: 'lesson_documents/pdf/_cover',
        layout: 'cg_plain_pdf',
        locals: { lesson_document: @lesson_document }
      }
    end

    def export(new_url)
      @lesson_document.pdf_refresh!(new_url)
      self
    end

    def url
      @lesson_document.pdf_url
    end

    def pdf_params(cover, debug: false)
      {
        cover: cover,
        disable_internal_links: false,
        disable_external_links: false,
        disposition: 'attachment',
        footer: { html: { template: 'lesson_documents/pdf/_footer',
                          layout: 'cg_plain_pdf',
                          locals:  { lesson_document: @lesson_document } },
                  line: false,
                  spacing: 2 },
        javascript_delay: 5000,
        header: { html: { template: 'lesson_documents/pdf/_header',
                          layout: 'cg_plain_pdf',
                          locals:  { lesson_document: @lesson_document } },
                  line: false,
                  spacing: 2 },
        layout: 'cg_pdf',
        locals: { lesson_document: @lesson_document },
        margin: { bottom: 18, left: 8, right: 8, top: 18 },
        show_as_html: debug,
        outline: { outline_depth: 3 },
        page_size: 'Letter',
        pdf: @lesson_document.pdf_title,
        print_media_type: false,
        template: 'lesson_documents/pdf/show',
        toc: { disable_dotted_lines: true,
               disable_links: false,
               disable_toc_links: false,
               disable_back_links: false,
               xsl_style_sheet: template_path("_toc--#{@lesson_document.subject}.xsl") }
      }
    end

    private

    def template_path(name)
      Rails.root.join('app', 'views', 'lesson_documents', 'pdf', name)
    end
  end
end
