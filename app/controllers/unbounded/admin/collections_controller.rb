module Unbounded
  module Admin
    class CollectionsController < AdminController
      before_action :find_resource

      def show
      end

      private
        def find_resource
          @collection = LobjectCollection.find(params[:id])
        end
    end
  end
end
