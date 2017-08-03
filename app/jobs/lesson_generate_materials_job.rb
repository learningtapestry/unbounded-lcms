# frozen_string_literal: true

class LessonGenerateMaterialsJob < ActiveJob::Base
  queue_as :default

  after_perform do |job|
    DocumentPdfGenerator.documents(job.arguments.first)
  end

  def perform(document, material = nil)
    document = DocumentPresenter.new document
    if material.present?
      generate_material(document, material)
    else
      document.materials.each { |m| generate_material(document, m) }
    end
  end

  private

  def material_filenames(material)
    basename = material.pdf_filename
    %W[#{basename}.pdf #{basename}.jpg]
  end

  def generate_material(document, material)
    material = MaterialPresenter.new material, lesson: document
    pdf_filename, thumb_filename = material_filenames(material)
    pdf = DocumentExporter::PDF::Material.new(material).export
    thumb = DocumentExporter::Thumbnail.new(pdf).export
    url = S3Service.upload pdf_filename, pdf
    thumb_url = S3Service.upload thumb_filename, thumb
    links = document.links
    document.update links: links.deep_merge('materials' => { material.id => { 'url' => url, 'thumb' => thumb_url } })
  end
end
