require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  setup do
    Curriculum.maps.each { |m| m.tree_or_create }
    Curriculum.regenerate_all_slugs
  end

  test 'show lesson details' do
    lesson = curriculums(:math_unit_1_lesson_1).resource

    get :show, slug: lesson.first_tree.slug.value
    assert_equal 200, response.status
    assert_not_nil assigns(:resource)
  end
end
