# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Material < BasePDF
      def template_path(name)
        File.join('documents', 'pdf', 'materials', name)
      end

      def export
        content = super
        pdf = CombinePDF.parse(content)
        return content if pdf.pages.size.even?
        @options[:blank_page] = true
        super
      end
    end
  end
end
