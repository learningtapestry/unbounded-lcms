module Unbounded
  class SearchController < UnboundedController
    def index
      @dropdown_options = DropdownOptions.new
      @search = LobjectSearch.new(params)
    end
  end
end
