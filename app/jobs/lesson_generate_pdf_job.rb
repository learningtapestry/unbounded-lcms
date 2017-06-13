class LessonGeneratePdfJob < ActiveJob::Base
  queue_as :default

  def perform(lesson_document, pdf_type:)
    exporter = DocumentExporter::PDF.new(lesson_document, pdf_type: pdf_type)
    pdf = exporter.export
    url = S3Service.upload "lesson_documents/#{exporter.filename}", pdf
    links = lesson_document.links
    lesson_document.update links: links.merge(pdf_key(pdf_type) => url)
  end

  private

  def pdf_key(pdf_type)
    return 'pdf' if pdf_type == 'full'
    "pdf_#{pdf_type}"
  end
end
