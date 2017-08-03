# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Document < BasePDF
      def template_path(name)
        File.join('documents', 'pdf', name)
      end

      def export
        content = super
        pdf = CombinePDF.parse(content)
        @document.links['materials'].each do |_, v|
          pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(v['url'])).body)
        end
        pdf.to_pdf
      end
    end
  end
end
