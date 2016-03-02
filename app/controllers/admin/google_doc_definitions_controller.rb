module Admin
  class GoogleDocDefinitionsController < AdminController
    include GoogleAuth

    def index
      @definitions = GoogleDocDefinition.order(:keyword)
    end

    def new
    end

    def import
      file_id = GoogleDoc.file_id_from_url(params[:google_doc_definition][:url])
      redirect_to :new_admin_google_doc_definition if file_id.blank?

      credentials = google_credentials
      GoogleDocDefinition.import(file_id, credentials)

      redirect_to :admin_google_doc_definitions, notice: t('.success')
    end
  end
end
