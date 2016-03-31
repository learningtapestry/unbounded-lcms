module Admin
  class ContentGuideDefinitionsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: :import

    def index
      @definitions = ContentGuideDefinition.order(:keyword)
    end

    def new
    end

    def import
      file_id = ContentGuide.file_id_from_url(params[:content_guide_definition][:url])
      redirect_to :new_admin_content_guide_definition if file_id.blank?

      ContentGuideDefinition.import(file_id, google_credentials)

      redirect_to :admin_content_guide_definitions, notice: t('.success')
    end
  end
end
