require 'test_helper'

class PagesTestCase < ActionDispatch::IntegrationTest
  def setup
    super
    admin  = users(:admin)
    @body  = Faker::Lorem.sentence(100)
    @page  = Page.create!(body: Faker::Lorem.sentence(100), title: Faker::Lorem.sentence(10), slug: Faker::Internet.slug)
    @title = Faker::Lorem.sentence(10)
    @slug  = Faker::Internet.slug
    login_as admin
  end

  def test_new_page
    visit '/admin/pages'
    click_link 'Add Page'
    assert_equal current_path, '/admin/pages/new'
    click_button 'Save'
    assert_equal find('.input.page_title.error .error').text, "can't be blank"
    assert_equal find('.input.page_body.error .error').text, "can't be blank"

    fill_in 'Title', with: @title
    fill_in 'Body',  with: @body
    fill_in 'Slug',  with: @slug
    click_button 'Save'
    page = Page.last
    assert_equal page.body,  @body
    assert_equal page.title, @title
    assert_equal current_path, "/pages/#{page.id}"
    assert_equal find('.callout.success').text, 'Page created successfully. ×'
  end

  def test_show_page
    logout
    visit "/pages/#{@page.id}"
    assert_equal find('h2').text,         @page.title
    assert_equal find('.page-body').text, @page.body
  end

  def test_edit_page
    visit '/admin/pages'
    within "#page_#{@page.id}" do
      click_link 'Edit'
    end
    assert_equal current_path, "/admin/pages/#{@page.id}/edit"
    fill_in 'Title', with: @title
    fill_in 'Body',  with: @body
    click_button 'Save'
    @page.reload
    assert_equal @page.body,  @body
    assert_equal @page.title, @title
    assert_equal current_path, "/pages/#{@page.id}"
    assert_equal find('.callout.success').text, 'Page updated successfully. ×'
  end

  def test_delete_page
    visit '/admin/pages'
    within "#page_#{@page.id}" do
      click_button 'Delete'
    end    
    assert_nil Page.find_by_id(@page.id)
    assert_equal current_path, '/admin/pages'
    assert_equal find('.callout.success').text, 'Page deleted successfully. ×'
  end
end
