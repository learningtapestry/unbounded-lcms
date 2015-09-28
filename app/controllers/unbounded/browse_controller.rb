require 'content/models'

module Unbounded
  class BrowseController < UnboundedController
    def index
      @search = LobjectFacets.new(params)
    end
  end
end
