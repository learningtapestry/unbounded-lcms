module Unbounded
  class PagesController < UnboundedController
    def show
      @page = Page.find(params[:id])
    end
  end
end
