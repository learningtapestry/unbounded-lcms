require 'rails_helper'

feature 'Remove Session' do
  given(:email) { Faker::Internet.email }
  given(:password) { Faker::Internet.password }
  given!(:admin) { create :admin, email: email, password: password, password_confirmation: password }

  scenario 'remove session' do
    visit '/'
    expect(has_cookie? '_content_session').to be false

    visit '/admin'
    assert '/users/sign_in', current_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(current_path).to eq '/'
    expect(has_cookie? '_content_session').to be true

    visit '/admin'
    click_on 'Sign out'
    expect(current_path).to eq '/'
    expect(has_cookie? '_content_session').to be false
  end

  def has_cookie?(name)
    Capybara.current_session.driver.request.cookies.key?(name)
  end
end
