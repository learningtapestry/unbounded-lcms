class LessonGenerateDocxJob < ActiveJob::Base
  queue_as :default

  def perform(lesson_document)
    docx = DocumentExporter::Docx.new(lesson_document).export
    file_name = "#{lesson_document.title.parameterize}_v#{lesson_document.version}.docx"
    url = S3Service.upload "lesson_documents/#{file_name}", docx
    links = lesson_document.links
    lesson_document.update links: links.merge(docx: url)
  end
end
