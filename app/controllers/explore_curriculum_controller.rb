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
      @curriculums = Curriculum.trees
        .grades
        .with_resources
        .where_subject(subject_params)
        .where_grade(grade_params)

      @props = ActiveModel::ArraySerializer.new(@curriculums,
        each_serializer: CurriculumSerializer,
        root: :results
      ).as_json.merge!(filterbar_props)
  end

  def set_show_props
    @curriculum = Curriculum.find(params[:id])
    @props = CurriculumSerializer.new(@curriculum, depth: 1).as_json
  end
end
