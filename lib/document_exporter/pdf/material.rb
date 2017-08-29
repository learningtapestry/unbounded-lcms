# frozen_string_literal: true

module DocumentExporter
  module PDF
    class Material < PDF::Base
      def export
        content = super
        pdf = CombinePDF.parse(content)
        return content if pdf.pages.size.even?
        @options[:blank_page] = true
        super
      end

      private

      def template_path(name)
        File.join('documents', 'pdf', 'materials', name)
      end
    end
  end
end
