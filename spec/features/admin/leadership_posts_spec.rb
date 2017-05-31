require 'rails_helper'

feature 'Leadership Posts' do
  given(:admin) { create :admin }

  given(:description) { Faker::Lorem.paragraph }
  given(:first_name) { Faker::Name.first_name }
  given(:last_name) { Faker::Name.last_name }
  given(:name) { "#{first_name} #{last_name}" }
  given(:school) { Faker::Lorem.sentence }
  given(:order) { 42 }
  given(:image_file) { Faker::Avatar.image }
  given!(:leadership_post) { create(:leadership_post) }

  background do
    sign_in admin
    visit '/admin/leadership_posts'
  end

  scenario 'new leadership post' do
    click_link 'Add Leadership Post'
    expect(current_path).to eq '/admin/leadership_posts/new'
    click_button 'Save'
    expect(find('.input.leadership_post_first_name.error .error').text).to eq "can't be blank"

    fill_in 'Order', with: order
    fill_in 'First name', with: first_name
    fill_in 'Last name', with: last_name
    fill_in 'School', with: school
    fill_in 'Description', with: description
    fill_in 'Image file', with: image_file
    click_button 'Save'

    leadership_post = LeadershipPost.last
    expect(leadership_post.order).to eq order
    expect(leadership_post.description).to eq description
    expect(leadership_post.name).to eq name
    expect(leadership_post.school).to eq school
    expect(leadership_post.image_file).to eq image_file

    expect(current_path).to eq '/admin/leadership_posts'
    expect(find('.callout.success').text).to eq 'Leadership Post created successfully. ×'
  end

  scenario 'Edit LeadershipPost' do
    within "#leadership_post#{leadership_post.id}" do
      click_link 'Edit'
    end
    expect(current_path).to eq "/admin/leadership_posts/#{leadership_post.id}/edit"

    fill_in 'Order', with: order
    fill_in 'First name', with: first_name
    fill_in 'Last name', with: last_name
    fill_in 'School', with: school
    fill_in 'Description', with: description
    fill_in 'Image file', with: image_file
    click_button 'Save'

    leadership_post.reload
    expect(leadership_post.order).to eq order
    expect(leadership_post.description).to eq description
    expect(leadership_post.name).to eq name
    expect(leadership_post.school).to eq school
    expect(leadership_post.image_file).to eq image_file

    expect(current_path).to eq '/admin/leadership_posts'
    expect(find('.callout.success').text).to eq 'Leadership Post updated successfully. ×'
  end

  scenario 'Delete LeadershipPost' do
    within "#leadership_post#{leadership_post.id}" do
      click_button 'Delete'
    end

    expect { leadership_post.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(current_path).to eq '/admin/leadership_posts'
    expect(find('.callout.success').text).to eq 'Leadership Post deleted successfully. ×'
  end
end
