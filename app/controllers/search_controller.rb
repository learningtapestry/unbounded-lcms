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
      qset = search_term.blank? ? Resource.all : Resource.search(search_term, limit: 100).records
      @resources = qset.includes(:curriculums => :curriculum_type).where_subject(subject_params)
                       .where_grade(grade_params)
                       .paginate(pagination_params.slice(:page, :per_page))
                       .order(created_at: pagination_params[:order])
                       # .where_type(??)  # facets => curriculum | instructions
    end

    def set_props
      @props = serialize_with_pagination(@resources,
        pagination: pagination_params,
        each_serializer: ResourceSerializer
      )
      @props.merge!(filterbar_props)
    end
end
