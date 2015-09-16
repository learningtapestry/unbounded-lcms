require 'content/models'

module Unbounded
  class BrowseController < UnboundedController
    layout "unbounded_new", only: [:home]

    def index
      @search = LobjectFacets.new(params)
    end

    def search
      @search = LobjectSearch.new(params)
    end

    def show
      @lobject = LobjectPresenter.new(Content::Models::Lobject.find(params[:id]))
    end

    def home
    end

  end
end
