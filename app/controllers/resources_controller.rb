class ResourcesController < ApplicationController
  before_action :find_resource

  def show_with_slug
    presenter, view, resource_variable =
      case @curriculum.current_level
      when :lesson then [LessonPresenter, 'lessons/show', '@lesson']
      else [LessonPresenter, 'lessons/show', '@lesson']
      end

    instance_variable_set(resource_variable, presenter.new(@resource))
    render view
  end

  protected
    def find_resource
      slug = ResourceSlug.find_by_value!(params[:slug])
      @resource = slug.resource
      @curriculum = CurriculumPresenter.new(slug.curriculum)
    end
end
