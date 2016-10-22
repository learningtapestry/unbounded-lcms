require 'test_helper'

class RemoveSessionTest < ActionDispatch::IntegrationTest
  def test_remove_session
    email = Faker::Internet.email
    password = Faker::Internet.password
    admin = User.create!(email: email, password: password)

    visit '/'
    assert_not has_cookie?('_content_session')

    visit '/admin'
    assert '/users/sign_in', current_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    assert '/', current_path
    assert has_cookie?('_content_session')

    visit '/admin'
    click_on 'Sign out'
    assert '/', current_path
    assert_not has_cookie?('_content_session')
  end

  private

  def has_cookie?(name)
    Capybara.current_session.driver.request.cookies.key?(name)
  end
end
