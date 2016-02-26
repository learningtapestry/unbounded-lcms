require 'googleauth/stores/file_token_store'
require 'googleauth/web_user_authorizer'

module Admin
  class GoogleDocsController < AdminController
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

      client_id = Google::Auth::ClientId.new(ENV['GOOGLE_OAUTH2_CLIENT_ID'], ENV['GOOGLE_OAUTH2_CLIENT_SECRET'])
      scope = %w(https://www.googleapis.com/auth/drive)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: 'tmp/cache/tokens.yml')
      authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, oauth2_callback_admin_google_docs_path)

      credentials = authorizer.get_credentials('importer', request)
      if credentials.nil?
        redirect_to authorizer.get_authorization_url(request: request)
        return
      end

      google_doc = GoogleDoc.import(file_id, credentials)

      redirect_to :admin_google_docs, notice: t('.success', name: google_doc.name)
    end
  end
end
