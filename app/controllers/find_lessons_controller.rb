class FindLessonsController < ApplicationController
  include Filterbar
  include Pagination

  before_action :find_lessons
  before_action :set_props

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  protected
    def find_lessons
      @lessons = Curriculum.trees.lessons.with_resources
        .where_subject(subject_params)
        .where_grade(grade_params)
        .paginate(pagination_params.slice(:page, :per_page))
        .order('resources.created_at desc')
    end

    def set_props
      @props = serialize_with_pagination(@lessons,
        pagination: pagination_params,
        each_serializer: CurriculumResourceSerializer,
      )
      @props.merge!(filterbar_props)
    end
end
