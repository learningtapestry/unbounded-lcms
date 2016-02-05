class Admin::ResourceChildrenController < Admin::AdminController
  def create
    child_params = params.require('resource_child').permit(:child_id, :resource_collection_id, :parent_id, :position)
    @resource_child = ResourceChild.create(child_params)
    @collection = @resource_child.collection
    respond_to do |format|
      format.html { redirect_to edit_admin_collection_path(@resource_child.resource_collection), notice: t('.success') }
      format.js
    end
  end
end
