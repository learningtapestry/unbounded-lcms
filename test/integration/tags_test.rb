require 'test_helper'

class TagsTestCase < ActionDispatch::IntegrationTest
  def setup
    super
    use_poltergeist

    admin = users(:admin)
    login_as admin
    visit '/admin/resources/new'
  end

  def test_create_alignment
    selector = '#alignments_modal'

    click_link 'Create Alignment'
    wait_until_modal_shown(selector)

    name = Faker::Lorem.sentence
    within selector do
      fill_in 'Name', with: name
      click_button 'Save'
      wait_until_modal_hidden(selector)
    end

    assert_equal find('.form-group.resource_alignments .selectize-input.items .item').text, "#{name}×"
  end

  def test_create_grade
    test_create_tag('Create Grade', :grades)
  end

  def test_create_resource_type
    test_create_tag('Create Resource Type', :resource_types)
  end

  def test_create_subject
    test_create_tag('Create Subject', :subjects)
  end

  def test_create_topic
    test_create_tag('Create Topic', :topics)
  end

  private
    def test_create_tag(title, association)
      modal_selector = "##{association}_modal"

      click_link title
      wait_until_modal_shown(modal_selector)

      within modal_selector do
        click_button 'Save'
        assert_equal find('.alert.alert-danger.error').text, "Name can't be blank"
      end

      name = Faker::Lorem.sentence

      within modal_selector do
        fill_in 'Name', with: name
        click_button 'Save'
        wait_until_modal_hidden(modal_selector)
      end

      assert_equal find(".form-group.resource_#{association} .selectize-input.items .item").text, "#{name}×"
    end

    def wait_until_modal_hidden(selector)
      has_css?(selector, visible: false)
    end

    def wait_until_modal_shown(selector)
      has_css?(selector, visible: true)
    end
end
