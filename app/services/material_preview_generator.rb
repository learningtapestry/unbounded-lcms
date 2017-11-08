# frozen_string_literal: true

#
# Generates and uploads PDF/GDoc files for material
#
class MaterialPreviewGenerator
  GDOC_RE = %r{docs.google.com/document/d/([^/]*)}i
  GDOC_ID_RE = %r{/open\?id=$}i

  attr_reader :error, :url

  def initialize(material, options = {})
    @material = material
    @options = options
  end

  def perform
    return false unless assign_document
    options[:type] == :pdf ? generate_pdf : generate_gdoc
  rescue => e
    @error = e.message
    return false
  end

  private

  attr_reader :material, :options

  def assign_document
    document = material.documents.last || Document.last
    unless document.present?
      @error = "Can't generate PDF for preview: no documents exist"
      return false
    end
    material.lesson = DocumentPresenter.new document

    true
  end

  def generate_gdoc
    folder_id = options[:folder_id]
    file_id = material.preview_links['gdoc'].to_s.match(GDOC_RE)&.[](1)
    @url = DocumentExporter::Gdoc::Material.new(material).export_to(folder_id, file_id: file_id).url
    return true if @url !~ GDOC_ID_RE

    raise 'GDoc generation failed. Please try again later'
  end

  def generate_pdf
    pdf_filename = "temp-materials-pdf/#{material.id}/#{material.base_filename}#{ContentPresenter::PDF_EXT}"
    pdf = DocumentExporter::PDF::Material.new(material).export
    @url = S3Service.upload pdf_filename, pdf
    true
  end
end
