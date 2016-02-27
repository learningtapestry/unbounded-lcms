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
      @lessons = Resource.lessons
        .where_subject(Subject.from_names(subject_params))
        .where_grade(Grade.from_names(grade_params))
        .paginate(pagination_params.slice(:page, :per_page))
        .order(created_at: pagination_params[:order])
    end

    def set_props
      @props = serialize_with_pagination(@lessons,
        pagination: pagination_params,
        each_serializer: LessonSerializer,
      )
      @props[:filterbar] = filterbar_props
    end
end
