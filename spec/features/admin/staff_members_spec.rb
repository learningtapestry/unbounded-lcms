require 'rails_helper'

feature 'Admin Staff Members' do
  given!(:admin) { create(:admin) }
  given!(:staff_member) { create(:staff_member) }

  given(:bio) { Faker::Lorem.paragraph }
  given(:first_name) { Faker::Name.first_name }
  given(:last_name) { Faker::Name.last_name }
  given(:name) { "#{first_name} #{last_name}" }
  given(:position) { Faker::Lorem.sentence }

  background do
    sign_in admin
    visit '/admin/staff_members'
  end

  scenario 'new staff_member' do
    click_link 'Add Staff Member'
    expect(current_path).to eq '/admin/staff_members/new'
    click_button 'Save'
    expect(find('.input.staff_member_first_name.error .error').text).to eq "can't be blank"

    fill_in 'First name', with: first_name
    fill_in 'Last name', with: last_name
    fill_in 'Position', with: position
    fill_in 'Bio', with: bio
    click_button 'Save'

    staff_member = StaffMember.last
    expect(staff_member.bio).to eq bio
    expect(staff_member.name).to eq name
    expect(staff_member.position).to eq position

    expect(current_path).to eq '/admin/staff_members'
    expect(find('.callout.success').text).to eq 'Staff Member created successfully. ×'
  end

  scenario 'edit staff_member' do
    within "#staff_member_#{staff_member.id}" do
      click_link 'Edit'
    end
    expect(current_path).to eq "/admin/staff_members/#{staff_member.id}/edit"

    fill_in 'First name', with: first_name
    fill_in 'Last name', with: last_name
    fill_in 'Position', with: position
    fill_in 'Bio', with: bio
    click_button 'Save'

    staff_member.reload
    expect(staff_member.bio).to eq bio
    expect(staff_member.name).to eq name
    expect(staff_member.position).to eq position

    expect(current_path).to eq '/admin/staff_members'
    expect(find('.callout.success').text).to eq 'Staff Member updated successfully. ×'
  end

  scenario 'delete staff_member' do
    within "#staff_member_#{staff_member.id}" do
      click_button 'Delete'
    end

    expect { staff_member.reload }.to raise_error ActiveRecord::RecordNotFound

    expect(current_path).to eq '/admin/staff_members'
    expect(find('.callout.success').text).to eq 'Staff Member deleted successfully. ×'
  end
end
