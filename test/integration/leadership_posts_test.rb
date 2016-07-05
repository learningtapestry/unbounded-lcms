require 'test_helper'

class LeadershipPostsTestCase < ActionDispatch::IntegrationTest
  def setup
    super

    @admin        = users(:admin)
    @dsc          = Faker::Lorem.paragraph
    @first_name   = Faker::Name.first_name
    @last_name    = Faker::Name.last_name
    @name         = "#{@first_name} #{@last_name}"
    @school       = Faker::Lorem.sentence
    @order        = 42
    @image_file   = Faker::Avatar.image
    @leadership_post = LeadershipPost.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)

    login_as @admin
    visit '/admin/leadership_posts'
  end

  def test_new_leadership_post
    click_link 'Add Leadership Post'
    assert_equal '/admin/leadership_posts/new', current_path
    click_button 'Save'
    assert_equal find('.input.leadership_post_first_name.error .error').text, "can't be blank"

    fill_in 'Order', with: @order
    fill_in 'First name', with: @first_name
    fill_in 'Last name', with: @last_name
    fill_in 'School', with: @school
    fill_in 'Description', with: @dsc
    fill_in 'Image file', with: @image_file
    click_button 'Save'

    leadership_post = LeadershipPost.last
    assert_equal @order, leadership_post.order
    assert_equal @dsc, leadership_post.description
    assert_equal @name, leadership_post.name
    assert_equal @school, leadership_post.school
    assert_equal @image_file, leadership_post.image_file

    assert_equal '/admin/leadership_posts', current_path
    assert_equal 'Leadership Post created successfully. ×', find('.callout.success').text
  end

  def test_edit_leadership_post

    within "#leadership_post#{@leadership_post.id}" do
      click_link 'Edit'
    end
    assert_equal "/admin/leadership_posts/#{@leadership_post.id}/edit", current_path

    fill_in 'Order', with: @order
    fill_in 'First name', with: @first_name
    fill_in 'Last name', with: @last_name
    fill_in 'School', with: @school
    fill_in 'Description', with: @dsc
    fill_in 'Image file', with: @image_file
    click_button 'Save'

    @leadership_post.reload
    assert_equal @order, @leadership_post.order
    assert_equal @dsc, @leadership_post.description
    assert_equal @name, @leadership_post.name
    assert_equal @school, @leadership_post.school
    assert_equal @image_file, @leadership_post.image_file

    assert_equal '/admin/leadership_posts', current_path
    assert_equal 'Leadership Post updated successfully. ×', find('.callout.success').text
  end

  def test_delete_leadership_post
    within "#leadership_post#{@leadership_post.id}" do
      click_button 'Delete'
    end

    assert_raise ActiveRecord::RecordNotFound do
      @leadership_post.reload
    end

    assert_equal '/admin/leadership_posts', current_path
    assert_equal 'Leadership Post deleted successfully. ×', find('.callout.success').text
  end
end
