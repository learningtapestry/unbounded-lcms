# frozen_string_literal: true

module DocumentExporter
  module PDF
    class TeacherMaterial < BasePDF
      def export
        content = super
        pdf = CombinePDF.parse(content)

        scope = @document.materials.where_metadata_any_of(config_for(:teacher))

        scope = scope.where(id: included_materials) if @options[:excludes].present?

        scope.each do |material|
          url = @document.links['materials']&.dig(material.id.to_s, 'url')
          pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(url)).body)
        end

        pdf.to_pdf
      end
    end
  end
end
