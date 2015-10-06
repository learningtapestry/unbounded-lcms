module Unbounded
  class LobjectsController < UnboundedController
    before_action :find_resource

    def show
      @lobject = LobjectPresenter.new(@lobject)
    end

    def preview
      render json: @lobject, serializer: LobjectPreviewSerializer
    end

    private
      def find_resource
        @lobject =
          if id = params[:id]
            Lobject.find(id)
          elsif slug = params[:slug]
            LobjectSlug.find_by_value!(slug).lobject
          end
      end
  end
end
