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
        if id = params[:id]
          @lobject = Lobject.find(id)
        elsif slug = params[:slug]
          slug = LobjectSlug.find_by_value!(slug)
          @lobject = slug.lobject
          @curriculum = UnboundedCurriculum.new(slug.lobject_collection, @lobject)
        end
      end
  end
end
