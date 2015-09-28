module Unbounded
  class LobjectsController < UnboundedController
    def show
      @lobject = LobjectPresenter.new(Lobject.find(params[:id]))
    end

    def preview
      render json: Lobject.find(params[:id]), serializer: LobjectPreviewSerializer
    end
  end
end
