module Admin
  class ContentGuidesController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: :import

    def index
      @content_guides = ContentGuide.order(updated_at: :desc)
    end

    def new
    end

    # GET /content_guides/dangling_links
    def dangling_links
      @content_guides = ContentGuide.all.map { |d| ContentGuidePresenter.new(d, request.base_url, view_context) }
    end

    # GET /content_guides/import
    def import
      file_id = ContentGuide.file_id_from_url(params[:content_guide][:url])
      redirect_to :new_admin_content_guides if file_id.blank?

      content_guide = ContentGuide.import(file_id, google_credentials)

      redirect_to :admin_content_guides, notice: t('.success', name: content_guide.name)
    end
  end
end
