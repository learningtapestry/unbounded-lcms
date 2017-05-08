module Admin
  class LessonDocumentsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: [:create, :new]

    def index
      @q = OpenStruct.new(params[:q])
      lessons = LessonDocument.all.order_by_curriculum.paginate(page: params[:page])

      lessons = filter_by_term(lessons, @q.search_term) if @q.search_term.present?
      lessons = filter_by_subject(lessons, @q.subject) if @q.subject.present?
      lessons = filter_by_grade(lessons, @q.grade) if @q.grade.present?

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

    def filter_by_term(lessons, search_term)
      term = "%#{search_term}%"
      lessons.joins(:resource)
             .where('resources.title ILIKE ? OR name ILIKE ?', term, term)
    end

    def filter_by_subject(lessons, subject)
      lessons.where_metadata(:subject, subject)
    end

    def filter_by_grade(lessons, grade)
      grade_value = grade.match(/grade (\d+)/).try(:[], 1) || grade
      lessons.where_metadata(:grade, grade_value)
    end
  end
end
