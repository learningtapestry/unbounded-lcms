ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'database_cleaner'
require 'rails/test_help'
require 'webmock/minitest'; WebMock.allow_net_connect!
require 'minitest/focus'
require 'minitest/rails/capybara'
require 'shoulda/context'
require 'shoulda/matchers'
require 'capybara/poltergeist';
require 'email_spec'

JsRoutes.generate!("app/assets/javascripts/generated/routes.js")

Capybara.javascript_driver = :poltergeist

# Increase Poltergeist timeout so we don't run into timeout errors.
# Ref. https://github.com/teampoltergeist/poltergeist/issues/571
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 10000)
end

class ActiveSupport::TestCase
  fixtures :all
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers; Warden.test_mode!

  def setup
    super
    DatabaseCleaner.start
  end

  def teardown
    super
    Capybara.reset_sessions!
    Capybara.use_default_driver if Capybara.current_driver == :poltergeist
    Rails.cache.clear
    DatabaseCleaner.clean
  end

  def use_poltergeist
    Capybara.current_driver = :poltergeist
  end
end

class IntegrationDatabaseTestCase < ActionDispatch::IntegrationTest
  def setup
    establish_connection(:integration)
    super
  end

  def teardown
    super
    establish_connection(Rails.env.to_s)
  end

  private
    def establish_connection(env)
      Dotenv.overload(".env.#{env}")
      config = Rails.application.config.database_configuration[env.to_s]
      ActiveRecord::Base.establish_connection(config)
    end
end
