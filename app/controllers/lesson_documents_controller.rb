class LessonDocumentsController < ApplicationController
  def show
    LessonDocument.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
end
