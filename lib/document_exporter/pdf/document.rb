# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Document < BasePDF
      def export
        content = super
        pdf = CombinePDF.parse(content)
        if (inc = included_materials).any?
          @document.links['materials']&.each do |id, v|
            next unless inc.include?(id)
            pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(v['url'])).body)
          end
        end
        pdf.to_pdf
      end
    end
  end
end
