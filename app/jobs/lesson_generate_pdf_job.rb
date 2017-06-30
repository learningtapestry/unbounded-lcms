class LessonGeneratePdfJob < ActiveJob::Base
  queue_as :default

  def perform(document, pdf_type:)
    document = DocumentPresenter.new document
    filename = "documents/#{document.pdf_filename type: pdf_type}"
    pdf = DocumentExporter::PDF.new(document, pdf_type: pdf_type).export
    url = S3Service.upload filename, pdf
    links = document.links
    document.update links: links.merge(pdf_key(pdf_type) => url)
  end

  private

  def pdf_key(pdf_type)
    return 'pdf' if pdf_type == 'full'
    "pdf_#{pdf_type}"
  end
end
