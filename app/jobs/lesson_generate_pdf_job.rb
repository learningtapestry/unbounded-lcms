class LessonGeneratePdfJob < ActiveJob::Base
  queue_as :default

  def perform(lesson_document, pdf_type:)
    lesson_document = LessonDocumentPresenter.new lesson_document
    filename = "lesson_documents/#{lesson_document.pdf_filename type: pdf_type}"
    pdf = DocumentExporter::PDF.new(lesson_document, pdf_type: pdf_type).export
    url = S3Service.upload filename, pdf
    links = lesson_document.links
    lesson_document.update links: links.merge(pdf_key(pdf_type) => url)
  end

  private

  def pdf_key(pdf_type)
    return 'pdf' if pdf_type == 'full'
    "pdf_#{pdf_type}"
  end
end
