module Admin
  class DocumentsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: %i(create new unit_bundles)

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
      @document = DocumentForm.new(Document)
    end

    def create
      @document = DocumentForm.new(Document, lesson_form_parameters, google_credentials)
      if @document.save
        redirect_to @document.document, notice: t('.success', name: @document.document.name)
      else
        render :new, alert: t('.error')
      end
    end

    def destroy
      @document = Document.find(params[:id])
      @document.destroy
      redirect_to :admin_documents, notice: t('.success')
    end

    def unit_bundles
      units = Resource.tree.units
      units.each do |unit|
        DocumentBundle::CATEGORIES.each { |c| DocumentBundleGenerateJob.perform_later unit, category: c }
      end
      redirect_to :admin_documents, notice: t('.success', num: units.count)
    end

    private

    def lesson_form_parameters
      params.require(:document_form).permit(:link)
    end
  end
end
