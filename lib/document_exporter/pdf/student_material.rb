# frozen_string_literal: true

module DocumentExporter
  module PDF
    class StudentMaterial < PDF::Base
      def export
        pdf = CombinePDF.new

        scope = @document.student_materials
        scope = scope.where(id: included_materials) if @options[:excludes].present?

        material_ids = ordered_materials scope.pluck(:id)
        pdf = combine_pdf_for pdf, material_ids
        pdf.to_pdf
      end
    end
  end
end
