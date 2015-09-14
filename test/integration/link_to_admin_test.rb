require 'test_helper'

class LinkToAdminTestCase < IntegrationTestCase
  def test_guest
    visit '/'
    within 'nav.navbar' do
      assert has_no_link?('Admin')
    end
  end

  def test_not_admin
    user = users(:mark)
    login_as user
    visit '/'
    within 'nav.navbar' do
      assert has_no_link?('Admin')
    end
  end

  def test_admin
    admin = users(:admin)
    login_as admin
    visit '/'
    within 'nav.navbar' do
      click_link 'Admin'
    end
    assert_equal current_path, '/unbounded/admin'
  end
end
