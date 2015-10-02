module Unbounded
  class CurriculumController < UnboundedController
    before_action :fix_params

    def index
      @dropdown_options = DropdownOptions.new(dropdown_params)
      @curriculum_roots = CurriculumSearch.new(params).curriculum_roots
    end

    def highlights
      render json: CurriculumSearch.new(params).highlights, root: nil
    end

    protected

    def fix_params
      params[:subject].present? && params[:subject].gsub!('_', ' ')
      params[:grade].present? && params[:grade].gsub!('_', ' ')
      if params[:standards].present? && !params[:standards].kind_of?(Array)
        params[:standards] = params[:standards].split(',').each { |s| s.gsub!('_', ' ') }
      end
    end

    def dropdown_params
      new_params = {}

      if params[:subject].present?
        raise 'Unknown subject' unless ['ela', 'math'].include?(params[:subject])
        new_params[:subject] = params[:subject] 
      end

      if params[:grade].present?
        new_params[:grade_id] = Grade.find_by!(grade: params[:grade]).id
      end

      if params[:standards].present?
        new_params[:standard_ids] = []
        params[:standards].each do |standard_name|
          new_params[:standard_ids] << Alignment.find_by!(name: standard_name).id
        end
      end

      new_params
    end
  end
end
