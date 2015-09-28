module Unbounded
  class SearchController < UnboundedController
    def index
      @search = LobjectSearch.new(params)
    end

    def curriculum
      render json: {
        curriculums: CurriculumSearch.new(params).results,
        dropdown_options: DropdownOptions.new(params).dropdown_options
      }
    end
  end
end
