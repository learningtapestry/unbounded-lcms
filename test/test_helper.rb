ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'content/test/test_helper'
require 'integration_database'
require 'webmock/minitest'; WebMock.allow_net_connect!

class ActiveSupport::TestCase
  fixtures :all
  include IntegrationDatabase
end

class ActionController::TestCase
  include Devise::TestHelpers
end
