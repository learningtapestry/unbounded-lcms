# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Base < DocumentExporter::Base
      def export
        content = render_template template_path('show'), layout: 'cg_pdf'
        WickedPdf.new.pdf_from_string(content, pdf_params)
      end

      protected

      def conbine_pdf_for(pdf, material_ids)
        material_ids.each do |id|
          next unless (url = @document.links['materials']&.dig(id.to_s, 'url'))
          pdf << CombinePDF.parse(Net::HTTP.get(URI.parse(url)))
        end
        pdf
      end

      private

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
          javascript_delay: 5000,
          outline: { outline_depth: 3 },
          page_size: 'Letter',
          print_media_type: false
        }.merge(pdf_custom_params)
      end
    end
  end
end
