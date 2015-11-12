ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'content/test/test_helper'
require 'webmock/minitest'; WebMock.allow_net_connect!
require 'minitest/focus'
require 'minitest/rails/capybara'
require 'shoulda/context'
require 'shoulda/matchers'
require 'capybara/poltergeist';
require 'email_spec'

Capybara.javascript_driver = :poltergeist

# Increase Poltergeist timeout so we don't run into timeout errors.
# Ref. https://github.com/teampoltergeist/poltergeist/issues/571
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, timeout: 10000)
end

class TestCase < ActiveSupport::TestCase
  include Content::Models
  include Content::Test::ContentFixtures
  include Content::Test::DatabaseCleanable
end

class ControllerTestCase < ActionController::TestCase
  include Content::Models
  include Content::Test::ContentFixtures
  include Content::Test::DatabaseCleanable
  include Content::Test::ElasticsearchTestable
  include Devise::TestHelpers
end

class IntegrationTestCase < ActionDispatch::IntegrationTest
  include Content::Models
  include Content::Test::ContentFixtures
  include Content::Test::DatabaseCleanable
  include Content::Test::ElasticsearchTestable
  include Capybara::DSL
  include Warden::Test::Helpers; Warden.test_mode!

  def teardown
    super
    Capybara.reset_sessions!
    Capybara.use_default_driver if Capybara.current_driver == :poltergeist
    Rails.cache.clear
  end

  def use_poltergeist
    Capybara.current_driver = :poltergeist
  end
end

class IntegrationDatabaseTestCase < IntegrationTestCase
  def setup
    establish_connection(:integration)
    Content::Models::Lobject.index_name 'integration_content-models-lobjects'
    super
  end

  def teardown
    super
    establish_connection(Rails.env.to_s)
    Content::Models::Lobject.index_name 'test_content-models-lobjects'
  end

  private
    def establish_connection(env)
      Dotenv.overload(".env.#{env}")
      config = Rails.application.config.database_configuration[env.to_s]
      ActiveRecord::Base.establish_connection(config)
    end
end
