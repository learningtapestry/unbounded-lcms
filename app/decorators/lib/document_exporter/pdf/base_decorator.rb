# frozen_string_literal: true

module DocumentExporter
  module PDF
    Base.module_eval do
      def pdf_content
        render_template template_path('show'), layout: 'cg_pdf'
      end

      def base_path(name)
        File.join('documents', 'pdf', name)
      end

      def pdf_custom_params
        @document.config.slice(:margin, :orientation)
      end

      def pdf_params
        {
          disable_internal_links: false,
          disable_external_links: false,
          disposition: 'attachment',
          footer: {
            content: render_template(base_path('_footer'), layout: 'cg_plain_pdf'),
            line: false,
            spacing: 2
          },
          javascript_delay: 500,
          outline: { outline_depth: 3 },
          page_size: 'Letter',
          print_media_type: false
        }.merge(pdf_custom_params)
      end
    end
  end
end