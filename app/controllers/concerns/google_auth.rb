require 'googleauth/stores/file_token_store'
require 'googleauth/web_user_authorizer'

module GoogleAuth
  extend ActiveSupport::Concern

  attr_reader :google_credentials

  def obtain_google_credentials
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_OAUTH2_CLIENT_ID'], ENV['GOOGLE_OAUTH2_CLIENT_SECRET'])
    scope = %w(https://www.googleapis.com/auth/drive)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: 'tmp/cache/tokens.yml')
    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, admin_google_oauth2_callback_path)

    credentials = authorizer.get_credentials(current_user.id, request)

    if credentials
      @google_credentials = credentials
    else
      redirect_to authorizer.get_authorization_url(request: request)
    end
  end
end
