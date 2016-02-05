class PagesControllerTest < ActionController::TestCase
  def test_about
    get 'show_slug', slug: 'about'
    assert_response :success
    assert_not_nil assigns(:page)
  end
end
