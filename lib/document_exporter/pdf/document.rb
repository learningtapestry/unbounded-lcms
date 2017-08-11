# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Document < BasePDF
      def export
        content = super
        pdf = CombinePDF.parse(content)
        @document.links['materials']&.each do |id, v|
          next if (inc = included_materials).any? && inc.include?(id)
          pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(v['url'])).body)
        end
        pdf.to_pdf
      end
    end
  end
end
