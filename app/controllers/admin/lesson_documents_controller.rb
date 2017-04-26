module Admin
  class LessonDocumentsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: :create

    def new
      @lesson_document = LessonDocumentForm.new
    end

    # GET /content_guides/import
    def create
      @lesson_document = LessonDocumentForm.new(permitted_params[:lesson_document_form], google_credentials)
      if @lesson_document.errors.empty?
        redirect_to [:show, :admin, @lesson_document], notice: t('.success', name: @lesson_document.name)
      else
        render :new, alert: t('.error')
      end
    end
  end
end
