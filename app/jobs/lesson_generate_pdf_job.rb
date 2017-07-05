# frozen_string_literal: true

class LessonGeneratePdfJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  def perform(document, options)
    document = DocumentPresenter.new document
    pdf = DocumentExporter::PDF.new(document, options).export

    filename = options[:filename].presence || "documents/#{document.pdf_filename type: options[:pdf_type]}"
    url = S3Service.upload filename, pdf

    links = document.links
    document.update links: links.merge(pdf_key(options[:pdf_type]) => url)
  end

  private

  def pdf_key(pdf_type)
    return 'pdf' if pdf_type == 'full'
    "pdf_#{pdf_type}"
  end
end
