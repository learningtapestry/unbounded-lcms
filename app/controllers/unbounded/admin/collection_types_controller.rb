module Unbounded
  module Admin
    class CollectionTypesController < Unbounded::AdminController
      before_action :find_resource, except: [:index, :new, :create]

      def index
        @collection_types = LobjectCollectionType.all
      end

      def new
        @collection_type = LobjectCollectionType.new
      end

      def create
        @collection_type = LobjectCollectionType.new(collection_type_params)

        if @collection_type.save
          redirect_to unbounded_admin_collection_type_url(@collection_type), notice: t('.success')
        else
          render :new
        end
      end

      def show
      end

      def edit
      end

      def update
        if @collection_type.update_attributes(collection_type_params)
          redirect_to unbounded_admin_collection_type_url(@collection_type), notice: t('.success')
        else
          render :edit
        end
      end

      private
        def collection_type_params
          params.require('content_models_lobject_collection_type').permit(:name)
        end

        def find_resource
          @collection_type = LobjectCollectionType.find(params[:id])
        end
    end
  end
end
