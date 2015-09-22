require 'test_helper'

class PagesTestCase < IntegrationTestCase
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
    visit unbounded_admin_path
    click_link 'Pages'
    assert_equal current_path, unbounded_admin_pages_path
    click_link 'Add Page'
    assert_equal current_path, new_unbounded_admin_page_path
    click_button 'Save'
    assert_equal find('.form-group.content_models_page_title.has-error .help-block').text, "can't be blank"
    assert_equal find('.form-group.content_models_page_body.has-error .help-block').text, "can't be blank"

    fill_in 'Title', with: @title
    fill_in 'Body',  with: @body
    fill_in 'Slug',  with: @slug
    click_button 'Save'
    page = Page.last
    assert_equal page.body,  @body
    assert_equal page.title, @title
    assert_equal current_path, unbounded_page_path(page.id)
    assert_equal find('.alert.alert-success').text, '× Page created successfully.'
  end

  def test_show_page
    logout
    visit unbounded_page_path(@page.id)
    assert_equal find('h2').text,         @page.title
    assert_equal find('.page-body').text, @page.body
  end

  def test_edit_page
    visit unbounded_admin_path
    click_link 'Pages'
    assert_equal current_path, unbounded_admin_pages_path
    within "#page_#{@page.id}" do
      click_link 'Edit'
    end
    assert_equal current_path, edit_unbounded_admin_page_path(@page.id)
    fill_in 'Title', with: @title
    fill_in 'Body',  with: @body
    click_button 'Save'
    @page.reload
    assert_equal @page.body,  @body
    assert_equal @page.title, @title
    assert_equal current_path, unbounded_page_path(@page.id)
    assert_equal find('.alert.alert-success').text, '× Page updated successfully.'
  end

  def test_delete_page
    visit unbounded_admin_path
    click_link 'Pages'
    assert_equal current_path, unbounded_admin_pages_path
    within "#page_#{@page.id}" do
      click_button 'Delete'
    end    
    assert_nil Page.find_by_id(@page.id)
    assert_equal current_path, unbounded_admin_pages_path
    assert_equal find('.alert.alert-success').text, '× Page deleted successfully.'
  end
end
