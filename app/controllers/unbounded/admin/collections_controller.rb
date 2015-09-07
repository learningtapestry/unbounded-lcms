module Unbounded
  module Admin
    class CollectionsController < AdminController
      before_action :find_resource

      def show
      end

      def edit
      end

      def update
        if @collection.update_attributes(collection_params)
          redirect_to unbounded_admin_collection_url(@collection), notice: t('.success')
        else
          render :edit
        end
      end

      private
        def collection_params
          params.require(:content_models_lobject_collection).permit(lobject_children_attributes: [:child_id, :id, :parent_id, :position])
        end

        def find_resource
          @collection = LobjectCollection.find(params[:id])
        end
    end
  end
end
