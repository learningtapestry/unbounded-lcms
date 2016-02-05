require 'test_helper'

class UnboundedPagesTestCase < ActionDispatch::IntegrationTest
  def setup
    super
    @grade      = resources(:unbounded_grade1)
    @lesson_1_1 = resources(:unbounded_lesson_1_1_1_1)
    @lesson_1_2 = resources(:unbounded_lesson_1_1_1_2)
    @lesson_1_3 = resources(:unbounded_lesson_1_1_1_3)
    @lesson_2_1 = resources(:unbounded_lesson_1_2_1_1)
    @lesson_3_1 = resources(:unbounded_lesson_1_3_1_1)
    @module1    = resources(:unbounded_module_1_1)
    @module2    = resources(:unbounded_module_1_2)
    @module3    = resources(:unbounded_module_1_3)
    @unit_1_1   = resources(:unbounded_unit_1_1_1)
    @unit_1_2   = resources(:unbounded_unit_1_1_2)
    @unit_1_3   = resources(:unbounded_unit_1_1_3)
    @unit_2_1   = resources(:unbounded_unit_1_2_1)
    @unit_3_1   = resources(:unbounded_unit_1_3_1)
  end

  def test_grade_page
    visit "/resources/#{@grade.id}"

    within '.left-sidebar' do
      grade_link  = find('.grade-title a')
      assert_equal grade_link[:href], '/curriculum/ela/grade_1'
      assert_equal grade_link.text,   'Grade 1'
    end
  end

  def test_module_page
    visit "/resources/#{@module1.id}"

    within '.left-sidebar' do
      grade_link  = find('.grade-title a')
      assert_equal grade_link[:href], '/curriculum/ela/grade_1'
      assert_equal grade_link.text,   'Grade 1'

      module_title_link = find('.module-title-title a.r-title.active')
      assert_equal module_title_link[:href], "/resources/#{@module1.id}"
      assert_equal module_title_link.text,   'Module 1'

      module_subtitle_link = find('.module-title-subtitle .r-subtitle.active')
      assert_equal module_subtitle_link[:href], "/resources/#{@module1.id}"
      assert_equal module_subtitle_link.text,   'Grade 1, Module 1 Subtitle'

      unit_links = all('a.module-nav-unit:not(.active)')
      assert_equal unit_links.size, 3
      assert_equal unit_links[0][:href], "/resources/#{@unit_1_1.id}"
      assert_equal unit_links[1][:href], "/resources/#{@unit_1_2.id}"
      assert_equal unit_links[2][:href], "/resources/#{@unit_1_3.id}"
    end
  end

  def test_unit_page
    # Unit 1
    visit "/resources/#{@unit_1_1.id}"

    within '.left-sidebar' do
      grade_link  = find('.grade-title a')
      assert_equal grade_link[:href], '/curriculum/ela/grade_1'
      assert_equal grade_link.text,   'Grade 1'

      module_title_link = find('.module-title-title a.r-title:not(.active)')
      assert_equal module_title_link[:href], "/resources/#{@module1.id}"
      assert_equal module_title_link.text,   'Module 1'

      module_subtitle_link = find('.module-title-subtitle .r-subtitle:not(.active)')
      assert_equal module_subtitle_link[:href], "/resources/#{@module1.id}"
      assert_equal module_subtitle_link.text,   'Grade 1, Module 1 Subtitle'

      current_unit_link = find('a.module-nav-unit.active')
      assert_equal current_unit_link[:href], "/resources/#{@unit_1_1.id}"
      assert_equal current_unit_link.find('figcaption').text, 'Unit 1'

      other_unit_links = all('a.module-nav-unit:not(.active)')
      assert_equal other_unit_links.size, 2
      assert_equal other_unit_links[0][:href], "/resources/#{@unit_1_2.id}"
      assert_equal other_unit_links[1][:href], "/resources/#{@unit_1_3.id}"

      unit_title_link = find('.unit-title a.active')
      assert_equal unit_title_link[:href], "/resources/#{@unit_1_1.id}"
      assert_equal unit_title_link.find('.r-title').text,    'Unit 1'
      assert_equal unit_title_link.find('.r-subtitle').text, 'Grade 1, Module 1, Unit 1 Subtitle'

      lesson_links = all('.lesson:not(.lesson-active) a')
      assert_equal lesson_links.size, 3
      assert_equal lesson_links[0][:href], "/resources/#{@lesson_1_1.id}"
      assert_equal lesson_links[1][:href], "/resources/#{@lesson_1_2.id}"
      assert_equal lesson_links[2][:href], "/resources/#{@lesson_1_3.id}"
    end

    # Unit 2
    visit "/resources/#{@unit_1_2.id}"

    within '.left-sidebar' do
      current_unit_link = find('a.module-nav-unit.active')
      assert_equal current_unit_link[:href], "/resources/#{@unit_1_2.id}"
      assert_equal current_unit_link.find('figcaption').text, 'Unit 2'

      other_unit_links = all('a.module-nav-unit:not(.active)')
      assert_equal other_unit_links.size, 2
      assert_equal other_unit_links[0][:href], "/resources/#{@unit_1_1.id}"
      assert_equal other_unit_links[1][:href], "/resources/#{@unit_1_3.id}"

      unit_title_link = find('.unit-title a.active')
      assert_equal unit_title_link[:href], "/resources/#{@unit_1_2.id}"
      assert_equal unit_title_link.text, 'Unit 2'
    end
  end

  def test_lesson_page
    # Lesson 1
    visit "/resources/#{@lesson_1_1.id}"

    within '.left-sidebar' do
      grade_link  = find('.grade-title a')
      assert_equal grade_link[:href], '/curriculum/ela/grade_1'
      assert_equal grade_link.text,   'Grade 1'

      module_title_link = find('.module-title-title a:not(.active)')
      assert_equal module_title_link[:href], "/resources/#{@module1.id}"
      assert_equal module_title_link.text,   'Module 1'    

      unit_title_link = find('.unit-title a:not(.active)')
      assert_equal unit_title_link[:href], "/resources/#{@unit_1_1.id}"
      assert_equal unit_title_link.find('.r-title').text,    'Unit 1'
      assert_equal unit_title_link.find('.r-subtitle').text, 'Grade 1, Module 1, Unit 1 Subtitle'

      current_lesson_link = find('.lesson.lesson-active a')
      assert_equal current_lesson_link[:href], "/resources/#{@lesson_1_1.id}"

      other_lesson_links = all('.lesson:not(.lesson-active) a')
      assert_equal other_lesson_links.size, 2
      assert_equal other_lesson_links[0][:href], "/resources/#{@lesson_1_2.id}"
      assert_equal other_lesson_links[1][:href], "/resources/#{@lesson_1_3.id}"
    end

    # Lesson 2
    visit "/resources/#{@lesson_1_2.id}"

    within '.left-sidebar' do
      current_lesson_link = find('.lesson.lesson-active a')
      assert_equal current_lesson_link[:href], "/resources/#{@lesson_1_2.id}"

      other_lesson_links = all('.lesson:not(.lesson-active) a')
      assert_equal other_lesson_links.size, 2
      assert_equal other_lesson_links[0][:href], "/resources/#{@lesson_1_1.id}"
      assert_equal other_lesson_links[1][:href], "/resources/#{@lesson_1_3.id}"
    end

    # Lesson 3
    visit "/resources/#{@lesson_1_3.id}"

    within '.left-sidebar' do
      current_lesson_link = find('.lesson.lesson-active a')
      assert_equal current_lesson_link[:href], "/resources/#{@lesson_1_3.id}"

      other_lesson_links = all('.lesson:not(.lesson-active) a')
      assert_equal other_lesson_links.size, 2
      assert_equal other_lesson_links[0][:href], "/resources/#{@lesson_1_1.id}"
      assert_equal other_lesson_links[1][:href], "/resources/#{@lesson_1_2.id}"
    end
  end

  def test_module_navigation_on_module_page
    # Module 1
    visit "/resources/#{@module1.id}"
    assert has_selector?('.module-title-prev.disabled a[href="#"]')
    assert has_selector?(".module-title-next:not(.disabled) a[href='/resources/#{@module2.id}']")

    # Module 2
    visit "/resources/#{@module2.id}"
    assert has_selector?(".module-title-prev:not(.disabled) a[href='/resources/#{@module1.id}']")
    assert has_selector?(".module-title-next:not(.disabled) a[href='/resources/#{@module3.id}']")

    # Module 3
    visit "/resources/#{@module3.id}"
    assert has_selector?(".module-title-prev:not(.disabled) a[href='/resources/#{@module2.id}']")
    assert has_selector?('.module-title-next.disabled a[href="#"]')
  end
end
