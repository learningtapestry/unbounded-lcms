module Admin
  class GoogleDocsController < AdminController
    include GoogleAuth

    before_action :obtain_google_credentials, only: :import

    def index
      @google_docs = GoogleDoc.order(updated_at: :desc)
    end

    def new
    end

    # GET /google_docs/dangling_links
    def dangling_links
      @google_docs = GoogleDoc.all.map { |d| GoogleDocPresenter.new(d, request.base_url, view_context) }
    end

    # GET /google_docs/import
    def import
      file_id = GoogleDoc.file_id_from_url(params[:google_doc][:url])
      redirect_to [:new, :admin, :google_docs] if file_id.blank?

      google_doc = GoogleDoc.import(file_id, google_credentials)

      redirect_to :admin_google_docs, notice: t('.success', name: google_doc.name)
    end
  end
end
