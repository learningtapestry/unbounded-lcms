# frozen_string_literal: true

class DocumentsController < ApplicationController
  include GoogleAuth

  before_action :set_document
  before_action :check_document_layout, only: :show
  before_action :check_params, only: :export

  def export
    params[:context] == 'pdf' ? export_pdf : export_gdoc
  end

  def export_status
    job_class = params[:context] == 'pdf' ? LessonGeneratePdfJob : LessonGenerateGdocJob
    job = job_class.find(params[:jid])
    data = { ready: job.nil? }
    data = data.merge(url: @doc.tmp_link(params[:key])) if params[:key]
    render json: data, status: :ok
  end

  def show
    @props = CurriculumMap.new(@document.resource).props
    respond_to do |format|
      format.html
    end
  end

  private

  def check_document_layout
    return if @document.layout('default').present?
    redirect_to admin_documents_path, alert: 'Document has to be re-imported.'
  end

  def check_params
    head :bad_request unless params[:type].present? && params[:context].present?
  end

  def export_gdoc
    type = params[:type]
    excludes = params[:excludes]

    return render(json: { url: @doc.links[@document.gdoc_key] }, status: :ok) if excludes.blank?

    folder = "#{@document.gdoc_folder}_#{SecureRandom.hex(10)}"
    options = {
      excludes: excludes,
      gdoc_folder: folder,
      content_type: type
    }
    job_id = LessonGenerateGdocJob.perform_later(@doc, options).job_id

    render json: { id: job_id, key: folder }, status: :ok
  end

  def export_pdf
    type = params[:type]
    excludes = params[:excludes]

    # Empty excludes - return pregenerated full PDF
    return render(json: { url: @doc.links[pdf_key(type)] }, status: :ok) if excludes.blank?

    filename = "documents-custom/#{SecureRandom.hex(10)}-#{@document.pdf_filename}"
    url = S3Service.url_for(filename)
    options = {
      excludes: excludes,
      filename: filename,
      content_type: type
    }
    job_id = LessonGeneratePdfJob.perform_later(@doc, options).job_id

    render json: { id: job_id, url: url }, status: :ok
  end

  def pdf_key(type)
    type == 'full' ? 'pdf' : "pdf_#{type}"
  end

  def set_document
    @doc = Document.find params[:id]
    @document = DocumentPresenter.new @doc, content_type: params[:type]
  end
end
