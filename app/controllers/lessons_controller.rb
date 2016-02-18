class LessonsController < ApplicationController
  include ReactRenderable

  before_action :find_lesson

  def show
    respond_to do |format|
      format.html { react_render props: lesson_props }
      format.json { render json: @lesson }
    end
  end

  protected
    def find_lesson
      @lesson = Resource.lessons.find(params[:id])
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
