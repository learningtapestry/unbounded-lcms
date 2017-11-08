# frozen_string_literal: true

class MaterialsController < ApplicationController
  before_action :set_material
  before_action :check_material, only: %i(preview_gdoc preview_pdf)

  GDOC_RE = %r{docs.google.com/document/d/([^/]*)}i
  GDOC_ID_RE = %r{/open\?id=$}i

  def preview_pdf
    # Check if preview already exists
    if (url = @material.preview_links['pdf']).present?
      return redirect_to url
    end

    @material.lesson = DocumentPresenter.new @document

    pdf_filename = "temp-materials-pdf/#{@material.id}/#{@material.base_filename}#{ContentPresenter::PDF_EXT}"
    pdf = DocumentExporter::PDF::Material.new(@material).export
    pdf_url = S3Service.upload pdf_filename, pdf

    links = @material.preview_links
    @material.update preview_links: links.merge(pdf: pdf_url)

    redirect_to pdf_url
  end

  def preview_gdoc
    if (url = @material.preview_links['gdoc']).present? && url !~ GDOC_ID_RE
      return redirect_to url
    end

    folder_id = ENV.fetch('GOOGLE_APPLICATION_PREVIEW_FOLDER_ID')
    file_id = @material.preview_links['gdoc'].to_s.match(GDOC_RE)&.[](1)
    gdoc_url = DocumentExporter::Gdoc::Material.new(@material).export_to(folder_id, file_id: file_id).url

    if gdoc_url =~ GDOC_ID_RE
      redirect_to material_path(@material), notice: 'GDoc generation failed. Please try again later'
    end

    links = @material.preview_links
    @material.update preview_links: links.merge(gdoc: gdoc_url)

    redirect_to gdoc_url
  end

  def show; end

  private

  def check_material
    head(:bad_request) if @material.pdf?

    @document = @material.documents.last || Document.last
    unless @document.present?
      redirect_to material_path(@material), notice: "Can't generate PDF for preview: no documents exist"
    end

    @material.lesson = DocumentPresenter.new @document
  end

  def set_material
    @material = MaterialPresenter.new(Material.find params[:id])
  end
end
