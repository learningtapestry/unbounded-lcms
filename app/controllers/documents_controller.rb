# frozen_string_literal: true

class DocumentsController < ApplicationController
  include GoogleAuth

  before_action :set_document
  before_action :check_pdf_params, only: :export_pdf
  before_action :obtain_google_credentials, only: :export_gdoc

  def export_gdoc
    content = render_to_string layout: 'ld_gdoc'
    exporter = DocumentExporter::Gdoc
                 .new(google_credentials)
                 .export(@document.title, content)
    redirect_to exporter.url
  end

  def export_pdf
    type = params[:type]
    excludes = params[:excludes]

    # Empty excludes - return pregenerated full PDF
    return render(json: { url: @doc.links[type] }, status: :ok) if excludes.blank?

    filename = "documents-custom/#{SecureRandom.hex(10)}-#{@document.pdf_filename type: type}"
    url = S3Service.url_for(filename)
    options = {
      excludes: excludes,
      filename: filename,
      pdf_type: type
    }
    job_id = LessonGeneratePdfJob.perform_later(@doc, options).job_id

    render json: { id: job_id, url: url }, status: :ok
  end

  def export_pdf_status
    job = LessonGeneratePdfJob.find params[:jid]
    render json: { ready: job.nil? }, status: :ok
  end

  def show
    @props = CurriculumMap.new(@document.resource).props
    respond_to do |format|
      format.html
    end
  end

  private

  def check_pdf_params
    head :bad_request unless params[:type].present?
  end

  def set_document
    @doc = Document.find params[:id]
    @document = DocumentPresenter.new @doc
    return if @document.layout.present?

    redirect_to admin_documents_path, alert: 'Document has to be re-imported.'
  end
end
