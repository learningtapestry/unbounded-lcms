require 'googleauth/stores/file_token_store'
require 'googleauth'

# will help connecting to the google api which is unfortunately
# interactive. To make it work, you have to obtain first the oauth
# authentication params from https://console.developers.google.com/apis/credentials
# for an application type "Other" and fill the .env.test
def get_google_credentials(user)
  obb_uri = 'urn:ietf:wg:oauth:2.0:oob'
  client_id = Google::Auth::ClientId.new(ENV['GOOGLE_OAUTH2_CLIENT_ID'], ENV['GOOGLE_OAUTH2_CLIENT_SECRET'])
  scope = %w(https://www.googleapis.com/auth/drive)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: 'test/support/google_secret.yml')
  authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

  user_id = user.id.to_s

  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
      url = authorizer.get_authorization_url(base_url: obb_uri)
      puts "Open #{url} in your browser and enter the resulting code:"
      code = STDIN.gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: obb_uri)
  end
  credentials
end

