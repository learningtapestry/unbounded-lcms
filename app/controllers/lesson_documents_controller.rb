class LessonDocumentsController < ApplicationController
  include CurriculumMapProps
  include GoogleAuth

  before_action :set_lesson_document
  before_action :obtain_google_credentials, only: :export_gdoc

  def export_docx
    content = render_to_string 'export', layout: 'ld_docx'
    file_name = "#{@lesson_document.title.parameterize}.docx"
    exporter = DocumentExporter::Docx.new.export(content)
    send_data exporter.data, filename: file_name, type: DocumentExporter::Docx::MIME_TYPE, status: :ok
  end

  def export_gdoc
    content = render_to_string 'export', layout: 'ld_gdoc'
    exporter = DocumentExporter::Gdoc
                 .new(google_credentials)
                 .export(@lesson_document.title, content)
    redirect_to exporter.url
  end

  def export_pdf
    exporter = DocumentExporter::PDF.new(@lesson_document)
    if params.key?('nocache') || (params.key?('debug') && Rails.env.development?)
      cover = render_to_string exporter.cover_params
      render exporter.pdf_params(cover, debug: params.key?('debug'))
    else
      redirect_to exporter.export(url_for(nocache: '')).url
    end
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
