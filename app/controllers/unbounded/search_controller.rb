module Unbounded
  class SearchController < UnboundedController
    before_action :fix_search_params

    def index
      @dropdown_options = DropdownOptions.new(dropdown_params)
      @search = LobjectSearch.new(params)
    end
  end
end
