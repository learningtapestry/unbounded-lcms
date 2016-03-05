module Admin
  class GoogleDocDefinitionsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: :import

    def index
      @definitions = GoogleDocDefinition.order(:keyword)
    end

    def new
    end

    def import
      file_id = GoogleDoc.file_id_from_url(params[:google_doc_definition][:url])
      redirect_to :new_admin_google_doc_definition if file_id.blank?

      GoogleDocDefinition.import(file_id, google_credentials)

      redirect_to :admin_google_doc_definitions, notice: t('.success')
    end
  end
end
