# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Document < PDF::Base
      def export
        content = super
        pdf = CombinePDF.parse(content)

        material_ids = document_materials_id
        material_ids &= included_materials if included_materials.any? || @options[:excludes].present?
        pdf = combine_pdf_for pdf, material_ids
        pdf.to_pdf
      end
    end
  end
end
