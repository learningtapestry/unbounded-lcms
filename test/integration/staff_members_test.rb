require 'test_helper'

class StaffMembersTestCase < ActionDispatch::IntegrationTest
  def setup
    super

    @admin        = users(:admin)
    @bio          = Faker::Lorem.paragraph
    @first_name   = Faker::Name.first_name
    @last_name    = Faker::Name.last_name
    @name         = "#{@first_name} #{@last_name}"
    @position     = Faker::Lorem.sentence
    @staff_member = StaffMember.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)

    login_as @admin
    visit '/admin/staff_members'
  end

  def test_new_staff_member
    click_link 'Add Staff Member'
    assert_equal '/admin/staff_members/new', current_path
    click_button 'Save'
    assert_equal find('.input.staff_member_first_name.error .error').text, "can't be blank"

    fill_in 'First name',     with: @first_name
    fill_in 'Last name',      with: @last_name
    fill_in 'Position', with: @position
    fill_in 'Bio',      with: @bio
    click_button 'Save'

    staff_member = StaffMember.last
    assert_equal @bio,      staff_member.bio
    assert_equal @name,     staff_member.name
    assert_equal @position, staff_member.position

    assert_equal '/admin/staff_members', current_path
    assert_equal 'Staff Member created successfully. ×', find('.callout.success').text
  end

  def test_edit_staff_member

    within "#staff_member_#{@staff_member.id}" do
      click_link 'Edit'
    end
    assert_equal "/admin/staff_members/#{@staff_member.id}/edit", current_path

    fill_in 'First name',     with: @first_name
    fill_in 'Last name',     with: @last_name
    fill_in 'Position', with: @position
    fill_in 'Bio',      with: @bio
    click_button 'Save'

    @staff_member.reload
    assert_equal @bio,      @staff_member.bio
    assert_equal @name,     @staff_member.name
    assert_equal @position, @staff_member.position

    assert_equal '/admin/staff_members', current_path
    assert_equal 'Staff Member updated successfully. ×', find('.callout.success').text
  end

  def test_delete_staff_member
    within "#staff_member_#{@staff_member.id}" do
      click_button 'Delete'
    end

    assert_raise ActiveRecord::RecordNotFound do
      @staff_member.reload
    end

    assert_equal '/admin/staff_members', current_path
    assert_equal 'Staff Member deleted successfully. ×', find('.callout.success').text
  end
end
