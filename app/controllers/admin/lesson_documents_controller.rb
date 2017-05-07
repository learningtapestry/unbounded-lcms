module Admin
  class LessonDocumentsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: [:create, :new]

    def index
      @lesson_documents = LessonDocument.all.order(:resource_id, updated_at: :desc).paginate(page: params[:page])
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

    private

    def lesson_form_parameters
      params.require(:lesson_document_form).permit(:link)
    end
  end
end
