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
      @lessons = Rails.cache.fetch("find_lessons/#{params_cache_key}") do
        queryset = Curriculum.trees.lessons.with_resources

        unless search_term.blank?
          search_ids = Search::Document.search(search_term, model_type: :resource, limit: 100).results.map {|r| r.model_id.to_i }
          queryset = queryset.where(item_id: search_ids).order_as_specified(item_id: search_ids)
        end

        queryset.where_subject(subject_params)
                .where_grade(grade_params)
                .paginate(pagination_params.slice(:page, :per_page))
                .order('resources.created_at desc')
      end
    end

    def set_props
      @props = Rails.cache.fetch("find_lessons/props/#{params_cache_key}") do
        serialize_with_pagination(@lessons,
          pagination: pagination_params,
          each_serializer: CurriculumResourceSerializer,
        )
      end
      @props.merge!(filterbar_props)
    end

    def params_cache_key
      @params_cache_key ||= begin
        pagination_key = pagination_params.sort.flatten.join(':')
        grade_key = grade_params.sort.flatten.join(':')
        subject_key = subject_params.sort.flatten.join(':')
        "subject::#{subject_key}/grade::#{grade_key}/search::#{search_term}/pagination::#{pagination_key}"
      end
    end
end
