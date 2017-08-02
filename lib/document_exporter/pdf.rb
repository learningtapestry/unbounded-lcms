# frozen_string_literal: true

module DocumentExporter
  class PDF
    def initialize(document, options = {})
      @document = document
      @options = { pdf_type: 'full' }.merge options
    end

    def export
      content = render_template 'show', layout: 'cg_pdf'
      WickedPdf.new.pdf_from_string(content, pdf_params)
    end

    private

    def pdf_params
      {
        disable_internal_links: false,
        disable_external_links: false,
        disposition: 'attachment',
        footer: {
          content: render_template('_footer'),
          line: false,
          spacing: 2
        },
        javascript_delay: 5000,
        margin: {
          bottom: 15,
          left: 8.46,
          right: 8.46,
          top: 8.46
        },
        outline: { outline_depth: 3 },
        page_size: 'Letter',
        print_media_type: false
      }
    end

    def render_template(name, layout: 'cg_plain_pdf')
      # Using backport of Rails 5 Renderer here
      ApplicationController.render(
        template: File.join('documents', 'pdf', name),
        layout: layout,
        locals: { document: @document, options: @options }
      )
    end
  end
end
