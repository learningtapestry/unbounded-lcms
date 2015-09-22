ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'content/test/test_helper'
require 'integration_database'
require 'webmock/minitest'; WebMock.allow_net_connect!
require 'minitest/focus'
require 'minitest/rails/capybara'
require 'shoulda/context'
require 'shoulda/matchers'

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
  include IntegrationDatabase
end

class IntegrationTestCase < ActionDispatch::IntegrationTest
  include Content::Models
  include Content::Test::ContentFixtures
  include Content::Test::DatabaseCleanable
  include Content::Test::ElasticsearchTestable
  include Capybara::DSL
  include Warden::Test::Helpers; Warden.test_mode!
  include IntegrationDatabase

  def teardown
    super
    Capybara.reset_sessions!
  end
end
