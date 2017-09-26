# frozen_string_literal: true

module Admin
  class DocumentsController < AdminController
    include GoogleAuth

    before_action :google_authorization, only: %i(create new reimport_selected)
    before_action :find_selected, only: %i(destroy_selected reimport_selected)

    def index
      @query = OpenStruct.new(params[:query])
      @documents = documents(@query)
    end

    def create
      @document = DocumentForm.new lesson_form_parameters, google_credentials
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
      jid = params[:jid]
      data = { status: DocumentParseJob.status(jid) }
      data[:result] = DocumentParseJob.fetch_result(jid) if data[:status] == :done
      render json: data, status: :ok
    end

    def new
      @document = DocumentForm.new
    end

    def reimport_selected
      bulk_import @documents.map(&:file_url)
      render :import
    end

    private

    def bulk_import(files)
      jobs = {}
      google_auth_id = GoogleAuthService.new(self).user_id
      files.each do |url|
        job_id = DocumentParseJob.perform_later(url, google_auth_id).job_id
        jobs[job_id] = { link: url, status: 'waiting' }
      end
      @props = { jobs: jobs, type: :documents }
    end

    def documents(query)
      docs = Document.order_by_curriculum.order(active: :desc).paginate(page: params[:page])

      docs = docs.actives unless query.inactive == '1'
      docs = docs.filter_by_term(query.search_term) if query.search_term.present?
      docs = docs.filter_by_subject(query.subject) if query.subject.present?
      docs = docs.filter_by_grade(query.grade) if query.grade.present?
      docs
    end

    def find_selected
      return head(:bad_request) unless params[:selected_ids].present?

      ids = params[:selected_ids].split(',')
      @documents = Document.where(id: ids)
    end

    def google_authorization
      options = {}
      if action_name == 'reimport_selected'
        return_path = admin_documents_path(selected_ids: params[:selected_ids])
        options[:redirect_to] = return_path
      end
      obtain_google_credentials options
    end

    def lesson_form_parameters
      params.require(:document_form).permit(:link, :link_fs, :reimport)
    end
  end
end
