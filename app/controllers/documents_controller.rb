class DocumentsController < ApplicationController
  include CurriculumMapProps
  include GoogleAuth

  before_action :set_target_document
  before_action :set_document
  before_action :obtain_google_credentials, only: :export_gdoc

  def export_gdoc
    content = render_to_string layout: 'ld_gdoc'
    exporter = DocumentExporter::Gdoc
                 .new(google_credentials)
                 .export(@document.title, content)
    redirect_to exporter.url
  end

  def show
    @curriculum = @document.resource.try(:first_tree)
    # set props to build Curriculum Map
    set_index_props
    respond_to do |format|
      format.html
    end
  end

  def show_teacher_materials
    @curriculum = @document.resource.try(:first_tree)
    # set props to build Curriculum Map
    set_index_props
    respond_to do |format|
      format.html
    end
  end

  def show_student_materials
    @curriculum = @document.resource.try(:first_tree)
    # set props to build Curriculum Map
    set_index_props
    respond_to do |format|
      format.html
    end
  end

  private

  def set_target_document
    @target_document = Document.find(params[:id])
  end

  def set_document
    @document = DocumentPresenter.new @target_document
  end
end
