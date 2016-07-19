require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def setup
    establish_connection(:integration)
    super
  end

  def teardown
    super
    restore_connection
  end

  def test_about
    get 'show_slug', slug: 'about'
    assert_response :success
  end

  def test_about_people
    get 'show_slug', slug: 'about_people'
    assert_response :success
  end

  def test_tos
    get 'show_slug', slug: 'tos'
    assert_response :success
  end

  def test_privacy
    get 'show_slug', slug: 'privacy'
    assert_response :success
  end

  def test_leadership
    get 'leadership'
    assert_response :success
  end
end
