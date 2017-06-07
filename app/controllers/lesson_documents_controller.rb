class LessonDocumentsController < ApplicationController
  include CurriculumMapProps
  include GoogleAuth

  before_action :set_lesson_document
  before_action :obtain_google_credentials, only: :export_gdoc

  def export_gdoc
    content = render_to_string layout: 'ld_gdoc'
    exporter = DocumentExporter::Gdoc
                 .new(google_credentials)
                 .export(@lesson_document.title, content)
    redirect_to exporter.url
  end

  def show
    @curriculum = @lesson_document.resource.try(:first_tree)
    # set props to build Curriculum Map
    set_index_props
    respond_to do |format|
      format.html
    end
  end

  private

  def set_lesson_document
    @lesson_document = LessonDocumentPresenter.new LessonDocument.find(params[:id])
  end
end
