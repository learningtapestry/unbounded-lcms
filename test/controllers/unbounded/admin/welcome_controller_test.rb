require 'test_helper'

class Unbounded::Admin::WelcomeControllerTest < ControllerTestCase
  def test_requires_admin_role
    get 'index'
    assert_redirected_to new_user_session_path
  end

  def test_allows_admin_role
    sign_in users(:admin)
    get 'index'
    assert_response :success
  end
end
