# frozen_string_literal: true

class MaterialGeneratePDFJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  after_perform do |job|
    DocumentGenerateJob.perform_later(job.arguments.second, check_queue: true)
  end

  def perform(material, document)
    material = MaterialPresenter.new material, lesson: DocumentPresenter.new(document)

    basename = material.pdf_filename
    pdf_filename = "#{basename}.pdf"
    thumb_filename = "#{basename}.jpg"

    pdf = DocumentExporter::PDF::Material.new(material).export
    thumb = DocumentExporter::Thumbnail.new(pdf).export

    pdf_url = S3Service.upload pdf_filename, pdf
    thumb_url = S3Service.upload thumb_filename, thumb

    new_links = {
      'materials' => {
        material.id.to_s => { 'url' => pdf_url, 'thumb' => thumb_url }
      }
    }

    document.with_lock do
      links = document.reload.links
      document.update links: links.deep_merge(new_links)
    end
  end
end
