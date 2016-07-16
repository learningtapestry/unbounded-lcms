require 'test_helper'

class ExploreCurriculumControllerTest < ActionController::TestCase
  def test_explore_curriculum
    get 'index'
    assert_response :success
  end
end
