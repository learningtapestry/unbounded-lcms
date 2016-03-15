require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  def test_search_index
    get 'index'
    assert_response :success
    assert_not_nil assigns(:props)
  end
end
