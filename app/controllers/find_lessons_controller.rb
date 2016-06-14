class FindLessonsController < ApplicationController
  include Filterbar
  include Pagination

  before_action :set_props

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  protected
    def set_props
      @props = begin
        if search_term.blank?
          serializer = CurriculumResourceSerializer
          @lessons = find_lessons

        else
          serializer = SearchCurriculumResourceSerializer
          @lessons = search_lessons
        end

        serialize_with_pagination(@lessons,
          pagination: pagination_params,
          each_serializer: serializer,
        )
      end
      @props.merge!(filterbar_props)
    end

    def find_lessons
      Curriculum.trees
                .lessons
                .with_resources
                .where_subject(subject_params)
                .where_grade(grade_params)
                .paginate(pagination_params.slice(:page, :per_page))
                .order('resources.subject', :hierarchical_position)
    end

    def search_lessons
      Search::Document.search(search_term, search_params.merge(doc_type: :lesson))
                      .paginate(pagination_params)
    end
end
