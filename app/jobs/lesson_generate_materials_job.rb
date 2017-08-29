# frozen_string_literal: true

class LessonGenerateMaterialsJob < ActiveJob::Base
  queue_as :default

  def perform(document, material = nil)
    if material.present?
      material.material_parts.each do |part|
        part.update!(content: EmbedEquations.call(part.content))
      end
      generate_material(document, material)
    else
      document.document_parts.each do |part|
        part.update!(content: EmbedEquations.call(part.content))
      end
      document.materials.each { |m| generate_material(document, m) }
    end

    DocumentGenerator.documents(document)
  end

  private

  def material_filenames(material)
    basename = material.pdf_filename
    %W[#{basename}.pdf #{basename}.jpg]
  end

  def generate_material(document, material)
    document = DocumentPresenter.new document
    material = MaterialPresenter.new material, lesson: document
    pdf_filename, thumb_filename = material_filenames(material)
    pdf = DocumentExporter::PDF::Material.new(material).export
    gdoc = DocumentExporter::Gdoc::Material.new(material).export
    thumb = DocumentExporter::Thumbnail.new(pdf).export
    url = S3Service.upload pdf_filename, pdf
    thumb_url = S3Service.upload thumb_filename, thumb
    links = document.links
    document.update links: links.deep_merge(
      'materials' => {
        material.id => {
          'gdoc' => gdoc.url,
          'thumb' => thumb_url,
          'url' => url
        }
      }
    )
  end
end
