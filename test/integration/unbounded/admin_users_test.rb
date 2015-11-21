require 'test_helper'

module Unbounded
  class AdminUsersTestCase < IntegrationTestCase
    include EmailSpec::Helpers

    def setup
      super
      @admin = users(:admin)
      @name = Faker::Lorem.name
      @email = Faker::Internet.email
      @unbounded_user = users(:unbounded)
      login_as @admin
    end

    def test_new_user_blank_email
      navigate_to_new_user

      click_button 'Save'

      assert_equal "can't be blank", page.find('.help-block').text
    end

    def test_new_user
      navigate_to_new_user
      
      fill_in 'Name', with: @name
      fill_in 'Email', with: @email
      click_button 'Save'

      @last_user = User.last
      assert_equal @name, @last_user.name
      assert_equal @email, @last_user.email
      assert_equal '/admin/users', current_path
      assert_password_reset_email @last_user
    end

    def test_edit_user_bad_org
      assert_raise ActiveRecord::RecordNotFound do
        visit "/admin/users/#{users(:lr).id}/edit"
      end
    end

    def test_edit_user_blank_email
      navigate_to_edit_user

      fill_in 'Email', with: ''
      click_button 'Save'

      @unbounded_user.reload
      assert_equal "/admin/users/#{@unbounded_user.id}", current_path
      assert_equal "can't be blank", page.find('.help-block').text
      assert_equal 'unbounded@unbounded.org', @unbounded_user.email
    end

    def test_edit_user
      navigate_to_edit_user

      fill_in 'Email', with: 'joe@unbounded.org'
      fill_in 'Name', with: 'Joe Jonah'
      click_button 'Save'

      @unbounded_user.reload
      assert_equal "/admin/users/#{@unbounded_user.id}/edit", current_path
      assert page.find('.alert-success').text.include? 'saved successfully'
      assert_equal 'joe@unbounded.org', @unbounded_user.email
      assert_equal 'Joe Jonah', @unbounded_user.name
    end

    def test_delete_user
      navigate_to_users

      within "#user_#{@unbounded_user.id}" do
        click_button 'Delete'
      end

      assert_equal '/admin/users', current_path
      assert page.find('.alert-success').text.include? 'deleted successfully'
      assert_nil User.find_by_id(@unbounded_user.id)
    end

    def test_reset_user_password
      navigate_to_users

      within "#user_#{@unbounded_user.id}" do
        click_button 'Reset password'
      end

      @unbounded_user.reload
      assert_equal '/admin/users', current_path
      assert page.find('.alert-success').text.include? 'will receive a password reset'
      assert_not_nil @unbounded_user.reset_password_token
      assert_password_reset_email @unbounded_user
    end

    def test_logged_out_password_reset
      logout

      visit '/users/sign_in'
      click_link 'Forgot your password?'
      assert_equal '/users/password/new', current_path

      fill_in 'Email', with: @unbounded_user.email
      click_button 'Send me reset password instructions'
      assert_equal '/users/sign_in', current_path
      assert_equal '× You will receive an email with instructions on how to reset your password in a few minutes.', find('.alert-success').text
      assert_password_reset_email @unbounded_user

      email = last_email_sent
      new_password_link = URI.extract(email.body.raw_source).first
      password = Faker::Internet.password
      visit new_password_link
      fill_in 'New password',         with: password
      fill_in 'Confirm new password', with: password
      click_button 'Change my password'

      assert_equal '/', current_path
      assert_equal '× Your password has been changed successfully. You are now signed in.', find('.alert-success').text
      assert @unbounded_user.reload.valid_password?(password)
    end

    protected

    def assert_password_reset_email(user)
      email = last_email_sent
      assert_equal ['no-reply@unbounded.org'],    email.from
      assert_equal 'Reset password instructions', email.subject
      assert_equal [user.email],                  email.to
    end

    def navigate_to_users
      visit '/admin'
      click_link 'Users'
      assert_equal '/admin/users', current_path
    end

    def navigate_to_new_user
      navigate_to_users
      click_link 'New user'
      assert_equal '/admin/users/new', current_path
    end

    def navigate_to_edit_user
      navigate_to_users
      click_link @unbounded_user.name
      assert_equal "/admin/users/#{@unbounded_user.id}/edit", current_path
    end
  end
end
