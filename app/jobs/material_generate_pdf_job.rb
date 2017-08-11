# frozen_string_literal: true

class MaterialGeneratePDFJob < ActiveJob::Base
  extend ResqueJob

  queue_as :default

  def perform(material, document)
    material = MaterialPresenter.new material, lesson: DocumentPresenter.new(document)

    basename = material.pdf_filename
    pdf_filename = "#{basename}.pdf"
    thumb_filename = "#{basename}.jpg"

    pdf = DocumentExporter::PDF::Material.new(material).export
    thumb = DocumentExporter::Thumbnail.new(pdf).export

    pdf_url = S3Service.upload pdf_filename, pdf
    thumb_url = S3Service.upload thumb_filename, thumb

    material.documents.each do |d|
      new_links = {
        'materials' => {
          material.id => { 'url' => pdf_url, 'thumb' => thumb_url }
        }
      }

      d.with_lock do
        links = d.reload.links
        d.reload.update links: links.deep_merge(new_links)
      end
    end

    DocumentGenerateJob.perform_later(document, check_queue: true)
  end
end
