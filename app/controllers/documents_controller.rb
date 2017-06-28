class DocumentsController < ApplicationController
  include CurriculumMapProps
  include GoogleAuth

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

  private

  def set_document
    doc = Document.find params[:id]
    @document = DocumentPresenter.new doc
  end
end
