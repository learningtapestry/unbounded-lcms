class MaterialsController < ApplicationController
  before_action :set_material

  def show; end

  private

  def set_material
    @material = Material.find params[:id]
  end
end
