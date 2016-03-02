class LessonsController < ApplicationController
  def show
    @lesson = LessonPresenter.new find_lesson
    @curriculum = CurriculumPresenter.new find_curriculum
    
    respond_to do |format|
      format.html
      format.json { render json: { lesson: @lesson, curriculum: @curriculum } }
    end
  end

  protected
    def find_lesson
      Resource.lessons.find(params[:id])
    end

    def find_curriculum
      if params[:node_id].present?
        @curriculum = Curriculum.trees.find_by!(
          id: params[:node_id],
          item_id: @lesson.id,
          item_type: 'Resource'
        )
      else
        @curriculum = @lesson.curriculums.trees.first
      end
    end
end
