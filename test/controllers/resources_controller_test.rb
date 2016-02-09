require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  test 'get /resources/:id redirects to slug path if resource has slug' do
    resource = resources(:unbounded_textbook)
    get :show, id: resource.id
    assert_redirected_to show_with_slug_path(resource.slug)
  end

  test 'get /resources/:id shows the resource if there is no slug' do
    resource = resources(:ela_curriculum_root)
    get :show, id: resource.id
    assert_response :success
  end

  test 'get /resources/:slug shows the resource' do
    resource = resources(:unbounded_textbook)
    get :show, slug: resource.slug
    assert_response :success
  end
end
