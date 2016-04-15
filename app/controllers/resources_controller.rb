class ResourcesController < ApplicationController
  def show
    find_resource_and_curriculum
    if params[:id].present? && slug = @curriculum.slug
      return redirect_to show_with_slug_path(slug.value), status: 301
    end
  end

  def related_instruction
    # TODO mock only data
    limit = params.fetch(:limit, 10).to_i
    @related_instruction = Curriculum.trees.with_resources.lessons[0...limit]
    render json: @related_instruction.map {|ri| CurriculumResourceSerializer.new(ri)}
  end

  protected
    def find_resource_and_curriculum
      if params[:slug].present?
        slug = ResourceSlug.find_by_value!(params[:slug])
        resource = slug.resource
        curriculum = slug.curriculum
      else
        resource = Resource.find(params[:id])
        curriculum = resource.first_tree
      end

      @resource = ResourcePresenter.new(resource)
      @grade_color_code = curriculum.grade_color_code
      @curriculum = CurriculumPresenter.new(curriculum)
    end
end
