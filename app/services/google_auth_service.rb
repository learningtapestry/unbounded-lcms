require 'googleauth/stores/redis_token_store'
require 'googleauth/web_user_authorizer'

class GoogleAuthService
  class << self
    include Rails.application.routes.url_helpers

    def authorizer
      @authorizer ||= begin
        client_id = Google::Auth::ClientId.new(ENV['GOOGLE_OAUTH2_CLIENT_ID'], ENV['GOOGLE_OAUTH2_CLIENT_SECRET'])
        token_store ||= Google::Auth::Stores::RedisTokenStore.new(redis: redis)
        scope = %w(https://www.googleapis.com/auth/drive)
        Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, admin_google_oauth2_callback_path)
      end
    end

    def redis
      @redis ||= Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'))
    end
  end

  attr_reader :context

  def initialize(context)
    @context = context
  end

  def authorization_url(options = {})
    authorizer.get_authorization_url options.merge(request: context.request)
  end

  def authorizer
    self.class.authorizer
  end

  def credentials
    @credentials ||= begin
      remove_expired_token
      authorizer.get_credentials(user_id, context.request)
    rescue Signet::AuthorizationError => e
      Rails.logger.warn e.message
    end
  end

  def user_id
    @user_id ||= "#{context.current_user.try(:id)}@#{context.request.remote_ip}"
  end

  private

  def redis
    self.class.redis
  end

  def remove_expired_token
    data = JSON(redis.get(user_token)) rescue nil
    return unless data

    expires_at = data['expiration_time_millis'].to_i / 1_000
    return if expires_at.zero?

    redis.del(user_token) if expires_at <= Time.now.to_i
  end

  def user_token
    @user_token ||= "#{Google::Auth::Stores::RedisTokenStore::DEFAULT_KEY_PREFIX}#{user_id}"
  end
end
