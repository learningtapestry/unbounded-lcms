require 'test_helper'

module Unbounded
  class WelcomeTestCase < IntegrationTestCase
    def test_show
      visit '/'
      assert has_css?('.home-page')
    end
  end
end
