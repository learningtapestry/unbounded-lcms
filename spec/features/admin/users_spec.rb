# frozen_string_literal: true

require 'rails_helper'

feature 'Admin users' do
  include EmailSpec::Helpers

  given!(:admin) { create :admin }
  given!(:user) { create :user, email: 'unbounded@unbounded.org' }
  given(:name) { Faker::Lorem.name }
  given(:email) { Faker::Internet.email }
  given(:reset_msg) { 'You will receive an email with instructions on how to reset your password in a few minutes. ×' }

  background do
    sign_in admin
  end

  scenario 'new user with blank email' do
    navigate_to_new_user

    click_button 'Save'
    expect(page.find('.input.error .error').text).to eq "can't be blank"
  end

  scenario 'new user' do
    navigate_to_new_user

    fill_in 'Name', with: name
    fill_in 'Email', with: email
    click_button 'Save'

    last_user = User.last
    expect(last_user.name).to eq name
    expect(last_user.email).to eq email
    expect(current_path).to eq '/admin/users'
    expect_reset_password_email_for last_user
  end

  scenario 'edit user with blank email' do
    navigate_to_edit_user

    fill_in 'Email', with: ''
    click_button 'Save'

    user.reload
    expect(current_path).to eq "/admin/users/#{user.id}"
    expect(page.find('.input.error .error').text).to eq "can't be blank"
    expect(user.email).to eq 'unbounded@unbounded.org'
  end

  scenario 'edit user' do
    navigate_to_edit_user

    fill_in 'Email', with: 'joe@unbounded.org'
    fill_in 'Name', with: 'Joe Jonah'
    click_button 'Save'

    user.reload
    expect(current_path).to eq "/admin/users/#{user.id}/edit"
    expect(page.find('.callout.success').text).to include('saved successfully')
    expect(user.email).to eq 'joe@unbounded.org'
    expect(user.name).to eq 'Joe Jonah'
  end

  scenario 'delete user' do
    visit '/admin/users'

    within "#user_#{user.id}" do
      click_button 'Delete'
    end

    expect(current_path).to eq '/admin/users'
    expect(page.find('.callout.success').text).to include('deleted successfully')
    expect(User.find_by id: user.id).to be_nil
  end

  scenario 'reset user password' do
    visit '/admin/users'

    within "#user_#{user.id}" do
      click_button 'Reset password'
    end

    user.reload
    expect(current_path).to eq '/admin/users'
    expect(page.find('.callout.success').text).to include('will receive a password reset')
    expect(user.reset_password_token).to_not be_nil
    expect_reset_password_email_for user
  end

  scenario 'logged out password reset' do
    logout

    visit '/users/sign_in'
    click_link 'Forgot your password?'
    expect(current_path).to eq '/users/password/new'

    fill_in 'Email', with: user.email
    click_button 'Send me reset password instructions'
    expect(current_path).to eq '/users/sign_in'
    expect(find('.callout.success').text).to eq reset_msg
    expect_reset_password_email_for user

    email = last_email_sent
    new_password_link = URI.extract(email.body.raw_source).first
    password = Faker::Internet.password
    visit new_password_link
    fill_in 'New password', with: password
    fill_in 'Confirm new password', with: password
    click_button 'Change my password'

    expect(current_path).to eq '/explore_curriculum'
    expect(find('.callout.success').text).to eq 'Your password has been changed successfully. You are now signed in. ×'
    expect(user.reload.valid_password?(password)).to be true
  end

  def navigate_to_new_user
    visit '/admin/users'
    click_link 'New user'
    expect(current_path).to eq '/admin/users/new'
  end

  def navigate_to_edit_user
    visit '/admin/users'
    click_link user.name
    expect(current_path).to eq "/admin/users/#{user.id}/edit"
  end

  def expect_reset_password_email_for(user)
    email = last_email_sent
    expect(email.from).to eq ['no-reply@unbounded.org']
    expect(email.subject).to eq 'Reset password instructions'
    expect(email.to).to eq [user.email]
  end
end
