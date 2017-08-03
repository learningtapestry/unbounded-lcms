# frozen_string_literal: true

module DocumentExporter
  module PDF
    class BasePDF
      def initialize(document, options = {})
        @document = document
        @options = options
      end

      def export
        content = render_template 'show', layout: 'cg_pdf'
        WickedPdf.new.pdf_from_string(content, pdf_params)
      end

      def template_path(_name)
        raise NotImplementedError
      end

      private

      def pdf_custom_params
        @document.config.slice(:margin, :orientation)
      end

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
          outline: { outline_depth: 3 },
          page_size: 'Letter',
          print_media_type: false
        }.merge(pdf_custom_params)
      end

      def render_template(name, layout: 'cg_plain_pdf')
        # Using backport of Rails 5 Renderer here
        ApplicationController.render(
          template: template_path(name),
          layout: layout,
          locals: { document: @document, options: @options }
        )
      end
    end
  end
end
