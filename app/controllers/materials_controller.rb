# frozen_string_literal: true

class MaterialsController < ApplicationController
  before_action :set_material
  before_action :check_material, only: %i(preview_gdoc preview_pdf)

  def preview_pdf
    if (url = @material.preview_links['pdf']).present?
      return redirect_to url
    end

    service = MaterialPreviewGenerator.new @material, type: :pdf
    if service.perform
      links = @material.preview_links
      @material.update preview_links: links.merge(pdf: service.url)
      redirect_to service.url
    else
      redirect_to material_path(@material), notice: service.error
    end
  end

  def preview_gdoc
    if (url = @material.preview_links['gdoc']).present? && url !~ MaterialPreviewGenerator::GDOC_BROKEN_RE
      return redirect_to url
    end

    preview_params = { folder_id: ENV.fetch('GOOGLE_APPLICATION_PREVIEW_FOLDER_ID'), type: :gdoc }
    service = MaterialPreviewGenerator.new @material, preview_params
    if service.perform
      links = @material.preview_links
      @material.update preview_links: links.merge(gdoc: service.url)
      redirect_to service.url
    else
      redirect_to material_path(@material), notice: service.error
    end
  end

  def show; end

  private

  def check_material
    head(:bad_request) if @material.pdf?
  end

  def set_material
    @material = MaterialPresenter.new(Material.find params[:id])
  end
end
