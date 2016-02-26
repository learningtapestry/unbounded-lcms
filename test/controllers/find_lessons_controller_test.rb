require 'test_helper'

class FindLessonsControllerTest < ActionController::TestCase
  def test_find_lessons
    get 'index'
    assert_response :success
    assert_not_nil assigns(:props)
  end
end
