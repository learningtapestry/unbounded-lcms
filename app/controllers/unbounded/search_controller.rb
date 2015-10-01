module Unbounded
  class SearchController < UnboundedController
    def index
      @search = LobjectSearch.new(params)
    end
  end
end
