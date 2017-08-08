class MaterialsController < ApplicationController
  before_action :set_material

  def show; end

  private

  def set_material
    @material = MaterialPresenter.new(Material.find params[:id])
  end
end
