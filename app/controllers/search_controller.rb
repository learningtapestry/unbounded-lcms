class SearchController < ApplicationController
  include Filterbar
  include Pagination

  before_action :find_resources
  before_action :set_props

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  protected
    def find_resources
      @resources = Resource.all
        .paginate(pagination_params.slice(:page, :per_page))
        .order(created_at: pagination_params[:order])
        # .where_subject(Subject.from_names(subject_params))
        # .where_grade(Grade.from_names(grade_params))
    end

    def set_props
      @props = serialize_with_pagination(@resources,
        pagination: pagination_params,
        each_serializer: LessonSerializer,  # ResourceSerializer
      )
      @props.merge!(filterbar_props)
    end
end
