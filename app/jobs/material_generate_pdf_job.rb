# frozen_string_literal: true

class MaterialGeneratePDFJob < ActiveJob::Base
  include ResqueJob

  include RetrySimple

  queue_as :default

  def perform(material, document)
    material_links = material.pdf? ? links_from_metadata(material) : links_from_upload(material, document)

    new_links = {
      'materials' => {
        material.id.to_s => material_links
      }
    }

    document.with_lock do
      links = document.reload.links
      document.update links: links.deep_merge(new_links)
    end

    DocumentGenerateJob.perform_later(document, check_queue: true)
  end

  private

  def links_from_upload(material, document)
    material = MaterialPresenter.new material, lesson: DocumentPresenter.new(document)

    basename = "#{DocumentExporter::PDF::Base.s3_folder}/#{material.pdf_filename}"
    pdf_filename = "#{basename}#{ContentPresenter::PDF_EXT}"
    thumb_filename = "#{basename}#{ContentPresenter::THUMB_EXT}"

    pdf = DocumentExporter::PDF::Material.new(material).export
    thumb = DocumentExporter::Thumbnail.new(pdf).export

    pdf_url = S3Service.upload pdf_filename, pdf
    thumb_url = S3Service.upload thumb_filename, thumb

    { 'url' => pdf_url, 'thumb' => thumb_url }
  end

  def links_from_metadata(material)
    { 'url' => material.metadata.pdf_url, 'thumb' => material.metadata.thumb_url }
  end
end
