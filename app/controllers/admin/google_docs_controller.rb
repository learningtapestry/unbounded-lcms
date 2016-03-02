module Admin
  class GoogleDocsController < AdminController
    include GoogleAuth

    def index
      @google_docs = GoogleDoc.order(updated_at: :desc)
    end

    def new
    end

    # GET /google_docs/dangling_links
    def dangling_links
      @google_docs = GoogleDoc.all.map { |d| GoogleDocPresenter.new(d) }
    end

    # GET /google_docs/oauth2_callback
    def oauth2_callback
      target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
      redirect_to target_url
    end

    # GET /google_docs/import
    def import
      file_id = GoogleDoc.file_id_from_url(params[:google_doc][:url])
      redirect_to [:new, :admin, :google_docs] if file_id.blank?

      credentials = google_credentials
      google_doc = GoogleDoc.import(file_id, credentials)

      redirect_to :admin_google_docs, notice: t('.success', name: google_doc.name)
    end
  end
end
