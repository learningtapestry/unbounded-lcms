# frozen_string_literal: true

require 'googleauth'
require 'googleauth/stores/file_token_store'

module GoogleApi
  class AuthCLIService
    CONFIG_SECRET_FILE = Rails.root.join('config', 'google', 'client_secret.json')
    CONFIG_TOKEN_FILE  = Rails.root.join('config', 'google', 'app_token.yaml')
    SCOPE = %w(https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/documents).freeze
    USER_ID = 'default'

    def self.authorizer
      @authorizer ||= begin
        client_id = Google::Auth::ClientId.from_file(CONFIG_SECRET_FILE)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: CONFIG_TOKEN_FILE)
        Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      end
    end

    def authorizer
      self.class.authorizer
    end

    def credentials
      @credentials ||= authorizer.get_credentials(USER_ID)
    end
  end
end
