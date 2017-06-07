class LessonGeneratePdfJob < ActiveJob::Base
  queue_as :default

  def perform(lesson_document)
    pdf = DocumentExporter::PDF.new(lesson_document).export
    file_name = "#{lesson_document.title.parameterize}_v#{lesson_document.version.presence || 1}.pdf"
    url = S3Service.upload "lesson_documents/#{file_name}", pdf
    links = lesson_document.links
    lesson_document.update links: links.merge(pdf: url)
  end
end
