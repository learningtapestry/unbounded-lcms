# frozen_string_literal: true

ENABLE_CACHING = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(
  ENV.fetch('ENABLE_CACHING', true)
)

Rails.application.configure do # rubocop:disable Metrics/BlockLength
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true # Set to false to test HTTP error pages
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = {
    host: ENV['APPLICATION_DOMAIN']
  }

  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  config.action_controller.action_on_unpermitted_parameters = :raise

  config.web_console.whitelisted_ips = %w(127.0.0.1/32 172.0.0.0/8)

  config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload if ENV['ENABLE_LIVERELOAD']

  if ENABLE_CACHING
    redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
    config.cache_store = :readthis_store, {
      expires_in: 1.hour.to_i,
      namespace: 'unbounded',
      redis: { url: redis_url, driver: :hiredis }
    }
  else
    config.cache_store = :null_store
  end

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
end
