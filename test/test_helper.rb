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
require 'capybara/poltergeist'; Capybara.javascript_driver = :poltergeist

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

  def wait_for_ajax
    wait_until { evaluate_script('jQuery.active').zero? }
  end

  def wait_until
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until yield
    end
  end
end
