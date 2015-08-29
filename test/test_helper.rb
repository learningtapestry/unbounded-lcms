ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'integration_database'
require 'webmock/minitest'; WebMock.allow_net_connect!

class ActiveSupport::TestCase
  fixtures :all
  include IntegrationDatabase
end

class ActionController::TestCase
  include IntegrationDatabase
end

class ActionMailer::TestCase
  include IntegrationDatabase
end

class ActionView::TestCase
  include IntegrationDatabase
end

class ActionDispatch::IntegrationTest
  include IntegrationDatabase
end
