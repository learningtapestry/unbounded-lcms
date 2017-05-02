class LessonDocumentsController < ApplicationController
  def show
    @lesson_document = LessonDocument.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
end
