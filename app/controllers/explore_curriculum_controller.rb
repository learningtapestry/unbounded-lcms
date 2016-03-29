class ExploreCurriculumController < ApplicationController
  include Filterbar

  before_action :set_index_props, only: [:index]
  before_action :set_show_props, only: [:show]

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @props }
    end
  end

  def set_index_props
      @curriculums = Rails.cache.fetch("explore_curriculums/#{params_cache_key}") do
        Curriculum.trees
          .grades
          .with_resources
          .where_subject(subject_params)
          .where_grade(grade_params)
      end

      @props = Rails.cache.fetch("explore_curriculums/props/#{params_cache_key}") do
        ActiveModel::ArraySerializer.new(@curriculums,
          each_serializer: CurriculumSerializer,
          root: :results
        ).as_json.merge!(filterbar_props)
      end
  end

  def set_show_props
    @curriculum = Curriculum.find(params[:id])
    @props = CurriculumSerializer.new(@curriculum, depth: 1).as_json
  end

  def params_cache_key
    @params_cache_key ||= begin
      grade_key = grade_params.sort.flatten.join(':')
      subject_key = subject_params.sort.flatten.join(':')
      "subject::#{subject_key}/grade::#{grade_key}"
    end
  end

end
