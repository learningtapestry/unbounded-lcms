require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Content
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.action_mailer.delivery_method = :aws_sdk

    config.active_record.raise_in_transactional_callbacks = true

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

    config.react.addons = true

    redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
    config.cache_store = :readthis_store, {
      expires_in: 1.hour.to_i,
      namespace: 'unbounded',
      redis: { url: redis_url, driver: :hiredis }
    }
  end
end
