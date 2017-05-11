module Admin
  class LessonDocumentsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: [:create, :new]

    def index
      @q = OpenStruct.new(params[:q])
      lessons = LessonDocument.all.order_by_curriculum.order(active: :desc).paginate(page: params[:page])

      lessons = lessons.actives unless @q.inactive == '1'
      lessons = lessons.filter_by_term(@q.search_term) if @q.search_term.present?
      lessons = lessons.filter_by_subject(@q.subject) if @q.subject.present?
      lessons = lessons.filter_by_grade(@q.grade) if @q.grade.present?

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
