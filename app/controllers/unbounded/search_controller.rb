module Unbounded
  class SearchController < UnboundedController
    def search_curriculum
      search = CurriculumSearch.new(params)
      render json: search.results
    end
  end
end
