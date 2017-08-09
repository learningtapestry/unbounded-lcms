# frozen_string_literal: true

require 'rails_helper'

feature 'Remove Session' do
  given(:email) { Faker::Internet.email }
  given(:password) { Faker::Internet.password }
  given(:admin) { create :admin, email: email, password: password, password_confirmation: password }

  scenario 'remove session' do
    visit '/'
    expect(has_cookie? '_content_session').to be true

    visit '/admin'
    expect(current_path).to eq new_user_session_path

    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: admin.password
    click_on 'Log in'
    expect(current_path).to eq '/admin'
    expect(has_cookie? '_content_session').to be true

    visit '/admin'
    click_on 'Sign out'
    expect(current_path).to eq new_user_session_path
    expect(has_cookie? '_content_session').to be true
  end

  def has_cookie?(name)
    Capybara.current_session.driver.request.cookies.key?(name)
  end
end
