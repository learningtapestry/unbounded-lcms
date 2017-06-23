class LessonGenerateDocxJob < ActiveJob::Base
  queue_as :default

  def perform(document)
    docx = DocumentExporter::Docx.new(document).export
    file_name = "#{document.title.parameterize}_v#{document.version}.docx"
    url = S3Service.upload "documents/#{file_name}", docx
    links = document.links
    document.update links: links.merge(docx: url)
  end
end
