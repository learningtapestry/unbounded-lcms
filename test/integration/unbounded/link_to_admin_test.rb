require 'test_helper'

module Unbounded
  class LinkToAdminTestCase < IntegrationTestCase
    def test_guest
      visit '/'
      assert has_no_link?('Administration')
    end

    def test_not_admin
      user = users(:mark)
      login_as user
      visit '/'
      assert has_no_link?('Administration')
    end

    def test_admin
      admin = users(:admin)
      login_as admin
      visit '/'
      click_link 'Administration'
      assert_equal current_path, unbounded_admin_path
    end
  end
end
