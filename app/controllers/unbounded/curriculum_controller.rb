module Unbounded
  class CurriculumController < UnboundedController
    before_action :fix_search_params

    def index
      @dropdown_options = DropdownOptions.new(dropdown_params)
      @curriculum_roots = CurriculumSearch.new(params).curriculum_roots
    end

    def highlights
      render json: CurriculumSearch.new(params).highlights, root: nil
    end
  end
end
