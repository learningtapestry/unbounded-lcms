# frozen_string_literal: true

module DocumentExporter
  module PDF
    class TeacherMaterial < BasePDF
      def export
        content = super
        pdf = CombinePDF.parse(content)

        scope = @document.materials.where_metadata_any_of(config_for(:teacher))
        scope = scope.where(id: included_materials) if @options[:excludes].present?

        material_ids = ordered_materials scope.pluck(:id)
        pdf = conbine_pdf_for pdf, material_ids
        pdf.to_pdf
      end
    end
  end
end
