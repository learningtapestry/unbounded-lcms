module Unbounded
  module Admin
    class LobjectChildrenController < AdminController
      def create
        child_params = params.require('content_models_lobject_child').permit(:child_id, :lobject_collection_id, :parent_id, :position)
        @lobject_child = LobjectChild.create(child_params)
        redirect_to edit_unbounded_admin_collection_path(@lobject_child.lobject_collection), notice: t('.success')
      end
    end
  end
end
