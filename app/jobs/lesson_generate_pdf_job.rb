# frozen_string_literal: true

class LessonGeneratePdfJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default
  PDF_EXPORTERS = {
    'full' => DocumentExporter::PDF::Document,
    'sm'   => DocumentExporter::PDF::StudentMaterial,
    'tm'   => DocumentExporter::PDF::TeacherMaterial
  }.freeze

  def perform(document, options)
    pdf_type = options[:pdf_type]
    document = DocumentPresenter.new document, pdf_type: pdf_type
    filename = options[:filename].presence || "documents/#{document.pdf_filename}"
    pdf = PDF_EXPORTERS[pdf_type].new(document, options).export
    url = S3Service.upload filename, pdf

    return if options[:excludes].present?

    document.update links: document.links.merge(pdf_key(options[:pdf_type]) => url)
  end

  private

  def pdf_key(type)
    type == 'full' ? 'pdf' : "pdf_#{type}"
  end
end
