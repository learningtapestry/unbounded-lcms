class LessonDocumentsController < ApplicationController
  include CurriculumMapProps

  def show
    @lesson_document = LessonDocumentPresenter.new LessonDocument.find(params[:id])
    @curriculum = @lesson_document.resource.try(:first_tree)
    # set props to build Curriculum Map
    set_index_props
    respond_to do |format|
      format.html
    end
  end
end
