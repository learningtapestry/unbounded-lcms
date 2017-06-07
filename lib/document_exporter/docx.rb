module DocumentExporter
  class Docx
    def initialize(lesson_document)
      @lesson_document = LessonDocumentPresenter.new lesson_document
    end

    def export
      PandocRuby.convert content, from: :html, to: :docx
    end

    private

    def content
      # Using backport of Rails 5 Renderer here
      @content ||= ApplicationController.render(
        layout: 'ld_docx',
        locals: { :@lesson_document => @lesson_document },
        template: 'lesson_documents/docx/export'
      )
    end
  end
end
