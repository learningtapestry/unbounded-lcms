# frozen_string_literal: true

module DocumentExporter
  module PDF
    class StudentMaterial < BasePDF
      def export
        pdf = CombinePDF.new

        scope = @document.materials
                  .where(id: included_materials)
                  .where_metadata('sheet_type': 'student')

        scope.each do |material|
          url = @document.links['materials']&.dig(material.id.to_s, 'url')
          pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(url)).body)
        end
        pdf.to_pdf
      end
    end
  end
end
