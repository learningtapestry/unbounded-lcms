# frozen_string_literal: true

module DocumentExporter
  module PDF
    class StudentMaterial < BasePDF
      def export
        pdf = CombinePDF.new
        @document.materials.where_metadata('sheet_type': 'student').each do |material|
          url = @document.links['materials'][material.id.to_s]['url']
          pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(url)).body)
        end
        pdf.to_pdf
      end
    end
  end
end
