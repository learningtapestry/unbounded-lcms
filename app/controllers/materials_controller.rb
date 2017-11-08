# frozen_string_literal: true

class MaterialsController < ApplicationController
  before_action :set_material
  before_action :check_material, only: %i(preview_gdoc preview_pdf)

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

  # def preview_gdoc
  #
  # end

  def show; end

  private

  def check_material
    head(:bad_request) if @material.pdf?

    @document = @material.documents.last || Document.last
    return true if @document.present?

    redirect_to admin_materials_path, norice: "Can't generate PDF for preview: no documents exist"
  end

  def set_material
    @material = MaterialPresenter.new(Material.find params[:id])
  end
end
