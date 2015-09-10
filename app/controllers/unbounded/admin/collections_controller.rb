module Unbounded
  module Admin
    class CollectionsController < AdminController
      before_action :find_resource, except: [:index, :new, :create]

      def index
        @collections = LobjectCollection.
                         select('lobject_collections.id, lobject_collection_type_id, lobject_id, COUNT(lobject_children.id) children_count').
                         joins('LEFT OUTER JOIN lobject_children ON lobject_children.lobject_collection_id = lobject_collections.id').
                         group('lobject_collections.id, lobject_collection_type_id, lobject_id').
                         order(id: :desc).
                         includes({ lobject: :lobject_titles }, :lobject_collection_type)
      end

      def new
        @collection = LobjectCollection.new
      end

      def create
        @collection = LobjectCollection.new(collection_params)

        if @collection.save
          redirect_to unbounded_admin_collection_url(@collection), notice: t('.success')
        else
          render :new
        end
      end

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

      def destroy
        @collection.destroy
        redirect_to :unbounded_admin_collections, notice: t('.success', collection_id: @collection.id)
      end

      private
        def collection_params
          params.require(:content_models_lobject_collection).permit(:lobject_collection_type_id, :lobject_id, lobject_children_attributes: [:_destroy, :child_id, :id, :parent_id, :position])
        end

        def find_resource
          @collection = LobjectCollection.find(params[:id])
        end
    end
  end
end
