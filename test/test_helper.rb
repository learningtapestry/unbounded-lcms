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

class TestCase < Content::Test::ContentTestBase
  include Content::Models
  include IntegrationDatabase
end

class ControllerTestCase
  include Devise::TestHelpers
  include IntegrationDatabase
end

class IntegrationTestCase < TestCase
  include Capybara::DSL
  include Warden::Test::Helpers

  Warden.test_mode!

  def teardown
    super
    Capybara.reset_sessions!
  end
end
