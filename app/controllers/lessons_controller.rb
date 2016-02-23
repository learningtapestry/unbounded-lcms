class LessonsController < ApplicationController
  def show
    @lesson = LessonPresenter.new find_lesson
    respond_to do |format|
      format.html
      format.json { render json: @lesson }
    end
  end

  protected
    def find_lesson
      Resource.lessons.find(params[:id])
    end
end
