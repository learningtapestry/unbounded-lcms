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
      @curriculums = Curriculum.grades
        .with_resources
        .where_subject(Subject.from_names(subject_params))
        .where_grade(Grade.from_names(grade_params))

      @props = ActiveModel::ArraySerializer.new(@curriculums,
        each_serializer: CurriculumSerializer,
        root: :results
      ).as_json.merge!(filterbar_props)
  end

  def set_show_props
    @curriculum = Curriculum.find(params[:id])
    @props = CurriculumSerializer.new(@curriculum, with_children: true).as_json
  end
end
