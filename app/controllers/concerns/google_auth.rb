require 'googleauth/stores/redis_token_store'
require 'googleauth/web_user_authorizer'

module GoogleAuth
  extend ActiveSupport::Concern

  attr_reader :google_credentials

  def obtain_google_credentials
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_OAUTH2_CLIENT_ID'], ENV['GOOGLE_OAUTH2_CLIENT_SECRET'])
    scope = %w(https://www.googleapis.com/auth/drive)
    redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'))
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: redis)
    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, admin_google_oauth2_callback_path)

    user_id = current_user.id.to_s

    remove_expired_token(redis, user_id)

    credentials = authorizer.get_credentials(user_id, request)

    if credentials
      @google_credentials = credentials
    else
      redirect_to authorizer.get_authorization_url(request: request)
    end
  end

  private

  def remove_expired_token(redis, user_id)
    key = user_token(user_id)

    data = JSON(redis.get(key)) rescue nil
    return unless data

    expires_at = Time.at(data['expiration_time_millis'] / 1_000) rescue nil
    return unless expires_at

    redis.del(key) if expires_at <= Time.now
  end

  def user_token(user_id)
    "#{Google::Auth::Stores::RedisTokenStore::DEFAULT_KEY_PREFIX}#{user_id}"
  end
end
