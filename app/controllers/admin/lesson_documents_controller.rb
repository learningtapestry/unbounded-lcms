module Admin
  class LessonDocumentsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: [:create, :new]

    def index
      @query = OpenStruct.new(params[:query])

      scope = LessonDocument.order_by_curriculum.order(active: :desc).paginate(page: params[:page])

      scope = scope.actives unless @query.inactive == '1'
      scope = scope.filter_by_term(@query.search_term) if @query.search_term.present?
      scope = scope.filter_by_subject(@query.subject) if @query.subject.present?
      scope = scope.filter_by_grade(@query.grade) if @query.grade.present?

      @lesson_documents = scope
    end

    def new
      @lesson_document = LessonDocumentForm.new(LessonDocument)
    end

    def create
      @lesson_document = LessonDocumentForm.new(LessonDocument, lesson_form_parameters, google_credentials)
      if @lesson_document.save
        redirect_to @lesson_document.lesson, notice: t('.success', name: @lesson_document.lesson.name)
      else
        render :new, alert: t('.error')
      end
    end

    def destroy
      @lesson_document = LessonDocument.find(params[:id])
      @lesson_document.destroy
      redirect_to :admin_lesson_documents, notice: t('.success')
    end

    private

    def lesson_form_parameters
      params.require(:lesson_document_form).permit(:link)
    end
  end
end
