require 'test_helper'

class LessonPresenterTest < ActiveSupport::TestCase
  setup do
    @unit = curriculums(:math_unit).resource
    @subject = subjects(:math)
    @grade = grades(:grade10)
    @unit.subjects << @subject
    @unit.grades << @grade
    @curriculum = curriculums(:math_unit_lesson)
    @lesson = @curriculum.resource
    @lesson.description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit.'
    @presenter = LessonPresenter.new @lesson
  end

  test 'delegate attributes' do
    assert_equal @lesson.id, @presenter.id
    assert_equal @lesson.title, @presenter.title
  end

  test 'unit' do
    assert_equal @unit, @presenter.unit
  end

  test 'subject' do
    assert_equal @subject, @presenter.subject
  end

  test 'grade' do
    assert_equal @grade, @presenter.grade
  end

  test 'subject_and_grade_title' do
    assert_equal 'Math / grade 10', @presenter.subject_and_grade_title
  end

  test 'teaser_text' do
    assert @presenter.teaser_text.length < @lesson.description.length
  end

  test 'tags' do
    @lesson.subjects << Subject.new(name: 'TagX')
    @lesson.subjects << Subject.new(name: 'TagY')
    assert_equal 'TagX, TagY', @presenter.tags
  end

  test 'curriculum' do
    assert_equal @curriculum, @presenter.curriculum
  end
end
