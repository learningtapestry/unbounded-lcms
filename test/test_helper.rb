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

class ActiveSupport::TestCase
  fixtures :all
  include FactoryGirl::Syntax::Methods
  include IntegrationDatabase
  include Warden::Test::Helpers

  Warden.test_mode!
end

class ActionController::TestCase
  include Devise::TestHelpers
end
