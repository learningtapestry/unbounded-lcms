# frozen_string_literal: true

module DocumentExporter
  module PDF
    class TeacherMaterial < BasePDF
      def template_path(name)
        File.join('documents', 'pdf', name)
      end
    end
  end
end
