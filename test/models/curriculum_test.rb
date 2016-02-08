require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
  setup do
    Curriculum.rebuild!
  end

  test '.where_subject finds curriculums with subjects of a particular kind' do
    resources(:math_curriculum_root).subjects << subjects(:math)
    resources(:ela_curriculum_root).subjects << subjects(:english_language_arts)
    assert_same_elements [curriculums(:math_map)], Curriculum.where_subject(subjects(:math))
  end

  test '#item_is_resource? returns true when item is a resource' do
    assert curriculums(:math_map).item_is_resource?
  end

  test '#item_is_resource? returns false when item is not a resource' do
    refute curriculums(:math_map_grade).item_is_resource?
  end

  test '#item_is_curriculum? returns true when item is a curriculum' do
    assert curriculums(:math_map_grade).item_is_curriculum?
  end

  test '#item_is_curriculum? returns false when item is not a curriculum' do
    refute curriculums(:math_map).item_is_curriculum?
  end

  test '#resource returns a resource when item is resource' do
    assert_equal resources(:math_curriculum_root), curriculums(:math_map).resource
  end

  test '#resource also returns a resource when item is curriculum' do
    assert curriculums(:math_map_grade).item_is_curriculum?
  end

  test '#current_level returns :lesson for lessons' do
    assert_equal :lesson, curriculums(:math_unit_lesson).current_level
  end

  test '#current_level returns :module for modules' do
    assert_equal :module, curriculums(:math_module).current_level
  end

  test '#current_level returns :grade for grades' do
    assert_equal :grade, curriculums(:math_grade).current_level
  end

  test '#current_level returns :unit for units' do
    assert_equal :unit, curriculums(:math_unit).current_level
  end

  test '#current_level returns :map for maps' do
    assert_equal :map, curriculums(:math_map).current_level
  end

  test '#next returns the next sibling' do
    assert_equal curriculums(:math_unit_lesson_1), curriculums(:math_unit_lesson).next
  end

  test '#previous returns the previous sibling' do
    assert_equal curriculums(:math_unit_lesson), curriculums(:math_unit_lesson_1).previous
  end

  test '#up goes up one level' do
    assert_equal curriculums(:math_unit), curriculums(:math_unit_lesson).up(1)
  end

end
