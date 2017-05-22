module Admin
  class LessonDocumentsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: [:create, :new]

    def index
      @param_obj = OpenStruct.new(params[:q])
      lessons = LessonDocument.order_by_curriculum.order(active: :desc).paginate(page: params[:page])

      lessons = lessons.actives unless @param_obj.inactive == '1'
      lessons = lessons.filter_by_term(@param_obj.search_term) if @param_obj.search_term.present?
      lessons = lessons.filter_by_subject(@param_obj.subject) if @param_obj.subject.present?
      lessons = lessons.filter_by_grade(@param_obj.grade) if @param_obj.grade.present?

      @lesson_documents = lessons
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
