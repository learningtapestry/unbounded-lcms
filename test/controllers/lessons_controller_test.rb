require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  setup do
    Curriculum.seeds.grades.with_resources.find_each { |g| g.create_tree }
  end

  test 'show lesson details' do
    lesson = curriculums(:math_unit_lesson).resource

    get :show, id: lesson.id
    assert_equal 200, response.status
    assert_not_nil assigns(:lesson)
  end
end
