require 'test_helper'

class Unbounded::Admin::WelcomeControllerTest < ControllerTestCase
  uses_integration_database

  def test_requires_admin_role
    get 'index'
    assert_redirected_to new_user_session_path
  end

  def test_allows_admin_role
    sign_in @admin
    get 'index'
    assert_response :success
  end

  def setup
    super
    @admin = Content::Models::User.find_by(email: 'content-admin@learningtapestry.com')
  end
end
