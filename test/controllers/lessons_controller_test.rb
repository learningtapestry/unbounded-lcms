require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  test 'show lesson details' do
    unit = curriculums(:math_unit)
    lesson = curriculums(:math_unit_lesson).resource

    get :show, id: lesson.id
    assert_equal 200, response.status
    assert_not_nil assigns(:lesson)
  end
end
