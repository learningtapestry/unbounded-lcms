class LessonsController < ApplicationController
  include ReactRenderable

  def show
    @lesson = LessonPresenter.new find_lesson
    respond_to do |format|
      format.html
      format.json { render json: @lesson }
    end
  end

  protected
    def find_lesson
      @lesson =  Resource.lessons.find(params[:id])
    end

    def lesson_props
      {
        entities: {
          lessons: { @lesson.id.to_i => LessonSerializer.new(@lesson).as_json }
        },
        lessonPage: @lesson.id.to_i
      }
    end
end
