# frozen_string_literal: true

module Admin
  class DocumentsController < AdminController
    include GoogleAuth
    include Reimportable

    before_action :google_authorization, only: %i(create new reimport_selected)
    before_action :find_selected, only: %i(destroy_selected reimport_selected)

    def index
      @query = OpenStruct.new(params[:query])
      @documents = AdminDocumentsQuery.call(@query, page: params[:page])
    end

    def create
      if gdoc_files.size > 1
        bulk_import gdoc_files
        return render :import
      end

      @document = reimport_lesson
      if @document.save
        redirect_to @document.document, notice: t('.success', name: @document.document.name)
      else
        render :new, alert: t('.error')
      end
    end

    def destroy
      @document = Document.find(params[:id])
      @document.destroy
      redirect_to admin_documents_path(query: params[:query]), notice: t('.success')
    end

    def destroy_selected
      count = @documents.destroy_all.count
      redirect_to admin_documents_path(query: params[:query]), notice: t('.success', count: count)
    end

    def import_status
      data = import_status_for DocumentParseJob
      render json: data, status: :ok
    end

    def new
      @document = DocumentForm.new
    end

    def reimport_selected
      bulk_import @documents
      render :import
    end

    private

    def bulk_import(docs)
      google_auth_id = GoogleAuthService.new(self).user_id
      reimport_materials = params[:with_materials].to_i.nonzero?
      jobs = docs.each_with_object({}) do |doc, jobs_|
        job_id = DocumentParseJob.perform_later(doc, google_auth_id, reimport_materials: reimport_materials).job_id
        link = doc.is_a?(Document) ? doc.file_url : doc
        jobs_[job_id] = { link: link, status: 'waiting' }
      end
      @props = { jobs: jobs, type: :documents }
    end

    def find_selected
      return head(:bad_request) unless params[:selected_ids].present?

      ids = params[:selected_ids].split(',')
      @documents = Document.where(id: ids)
    end

    def gdoc_files
      @gdoc_files ||= begin
        link = form_params[:link]
        if link =~ %r{/drive/(.*/)?folders/}
          DocumentDownloader::Gdoc.list_files(link, google_credentials)
        else
          [link]
        end
      end
    end

    def google_authorization
      options = {}
      if action_name == 'reimport_selected'
        return_path = admin_documents_path(selected_ids: params[:selected_ids])
        options[:redirect_to] = return_path
      end
      obtain_google_credentials options
    end

    def form_params
      @lf_params ||=
        begin
          data = params.require(:document_form).permit(:link, :link_fs, :reimport, :with_materials)
          data.delete(:with_materials) if data[:with_materials].to_i.zero?
          data
        end
    end

    def reimport_lesson
      reimport_lesson_materials if form_params[:with_materials].present?

      DocumentForm.new form_params.except(:with_materials), google_credentials
    end

    def reimport_lesson_materials
      file_id = DocumentDownloader::Gdoc.file_id_for form_params['link']
      doc = Document.actives.find_by(file_id: file_id)
      return unless doc

      doc.materials.each do |material|
        MaterialForm.new({ link: material.file_url, source_type: material.source_type }, google_credentials).save
      end
    end
  end
end
