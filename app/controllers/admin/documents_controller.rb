# frozen_string_literal: true

module Admin
  class DocumentsController < AdminController
    include GoogleAuth

    before_action :google_authorization, only: %i(create new reimport_selected unit_bundles)
    before_action :find_selected, only: %i(destroy_selected reimport_selected)

    def index
      @query = OpenStruct.new(params[:query])

      scope = Document.order_by_curriculum.order(active: :desc).paginate(page: params[:page])

      scope = scope.actives unless @query.inactive == '1'
      scope = scope.filter_by_term(@query.search_term) if @query.search_term.present?
      scope = scope.filter_by_subject(@query.subject) if @query.subject.present?
      scope = scope.filter_by_grade(@query.grade) if @query.grade.present?

      @documents = scope
    end

    def new
      @document = DocumentForm.new
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

    def reimport_selected
      @results = []
      @documents.each do |material|
        link = material.file_url
        form = DocumentForm.new({ link: link }, google_credentials)
        res = if form.save
                OpenStruct.new(ok: true, link: link, document: form.document)
              else
                OpenStruct.new(ok: false, link: link, errors: form.errors[:link])
              end
        @results << res
      end
      msg = render_to_string(partial: 'admin/documents/import_results', layout: false, locals: { results: @results })
      redirect_to admin_documents_path(query: params[:query]), notice: msg
    end

    def unit_bundles
      units = Resource.tree.units
      units.each do |unit|
        DocumentBundle::CATEGORIES.each { |c| DocumentBundleGenerateJob.perform_later unit, category: c }
      end
      redirect_to :admin_documents, notice: t('.success', num: units.count)
    end

    private

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
