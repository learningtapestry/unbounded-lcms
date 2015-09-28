require 'test_helper'

class UnboundedPagesTestCase < IntegrationTestCase
  def setup
    super
    @grade      = lobjects(:unbounded_grade1)
    @lesson_1_1 = lobjects(:unbounded_lesson_1_1_1_1)
    @lesson_1_2 = lobjects(:unbounded_lesson_1_1_1_2)
    @lesson_1_3 = lobjects(:unbounded_lesson_1_1_1_3)
    @lesson_2_1 = lobjects(:unbounded_lesson_1_2_1_1)
    @lesson_3_1 = lobjects(:unbounded_lesson_1_3_1_1)
    @module1    = lobjects(:unbounded_module_1_1)
    @module2    = lobjects(:unbounded_module_1_2)
    @module3    = lobjects(:unbounded_module_1_3)
    @unit1      = lobjects(:unbounded_unit_1_1_1)
    @unit2      = lobjects(:unbounded_unit_1_1_2)
  end

  def test_module_page
    visit "/unbounded/show_new/#{@module1.id}"

    grade_link  = find('a.module-title-grades:not(.active)')
    assert_equal grade_link[:href], "/unbounded/show_new/#{@grade.id}"
    assert_equal grade_link.text,   'Grade 1'

    module_link = find('a.active.module-title-module')
    assert_equal module_link[:href], "/unbounded/show_new/#{@module1.id}"
    assert_equal module_link.text,   'Module 1'

    unit_links = all('a.module-nav-unit')
    assert_equal unit_links.size, 2
    assert_equal unit_links.first[:href], "/unbounded/show_new/#{@unit1.id}"
    assert_equal unit_links.first.text,   'Unit 1'
    assert_equal unit_links.last[:href],  "/unbounded/show_new/#{@unit2.id}"
    assert_equal unit_links.last.text,    'Unit 2'
  end

  def test_unit_page
    visit "/unbounded/show_new/#{@unit1.id}"

    grade_link  = find('a.module-title-grades:not(.active)')
    assert_equal grade_link[:href], "/unbounded/show_new/#{@grade.id}"
    assert_equal grade_link.text,   'Grade 1'

    module_link = find('a.module-title-module:not(.active)')
    assert_equal module_link[:href], "/unbounded/show_new/#{@module1.id}"
    assert_equal module_link.text,   'Module 1'    

    unit_link = find('a.active.unit-title')
    assert_equal unit_link[:href], "/unbounded/show_new/#{@unit1.id}"
    assert_equal unit_link.text,   'Unit 1'

    lesson_links = all('div.lesson:not(.lesson-active) a:not(.disabled)')
    assert_equal lesson_links.size, 3
    assert_equal lesson_links[0][:href], "/unbounded/show_new/#{@lesson_1_1.id}"
    assert_equal lesson_links[1][:href], "/unbounded/show_new/#{@lesson_1_2.id}"
    assert_equal lesson_links[2][:href], "/unbounded/show_new/#{@lesson_1_3.id}"
  end

  def test_lesson_page
    # Lesson 1
    visit "/unbounded/show_new/#{@lesson_1_1.id}"

    grade_link  = find('a.module-title-grades:not(.active)')
    assert_equal grade_link[:href], "/unbounded/show_new/#{@grade.id}"
    assert_equal grade_link.text,   'Grade 1'

    module_link = find('a.module-title-module:not(.active)')
    assert_equal module_link[:href], "/unbounded/show_new/#{@module1.id}"
    assert_equal module_link.text,   'Module 1'    

    unit_link = find('a.unit-title:not(.active)')
    assert_equal unit_link[:href], "/unbounded/show_new/#{@unit1.id}"
    assert_equal unit_link.text,   'Unit 1'    

    current_lesson_link = find('div.lesson.lesson-active a:not(.disabled)')
    assert_equal current_lesson_link[:href], "/unbounded/show_new/#{@lesson_1_1.id}"

    other_lesson_links = all('div.lesson:not(.lesson-active) a:not(.disabled)')
    assert_equal other_lesson_links.size, 2
    assert_equal other_lesson_links[0][:href], "/unbounded/show_new/#{@lesson_1_2.id}"
    assert_equal other_lesson_links[1][:href], "/unbounded/show_new/#{@lesson_1_3.id}"

    # Lesson 2
    visit "/unbounded/show_new/#{@lesson_1_2.id}"

    grade_link  = find('a.module-title-grades:not(.active)')
    assert_equal grade_link[:href], "/unbounded/show_new/#{@grade.id}"
    assert_equal grade_link.text,   'Grade 1'

    module_link = find('a.module-title-module:not(.active)')
    assert_equal module_link[:href], "/unbounded/show_new/#{@module1.id}"
    assert_equal module_link.text,   'Module 1'    

    unit_link = find('a.unit-title:not(.active)')
    assert_equal unit_link[:href], "/unbounded/show_new/#{@unit1.id}"
    assert_equal unit_link.text,   'Unit 1'    

    current_lesson_link = find('div.lesson.lesson-active a:not(.disabled)')
    assert_equal current_lesson_link[:href], "/unbounded/show_new/#{@lesson_1_2.id}"

    other_lesson_links = all('div.lesson:not(.lesson-active) a:not(.disabled)')
    assert_equal other_lesson_links.size, 2
    assert_equal other_lesson_links[0][:href], "/unbounded/show_new/#{@lesson_1_1.id}"
    assert_equal other_lesson_links[1][:href], "/unbounded/show_new/#{@lesson_1_3.id}"

    # Lesson 3
    visit "/unbounded/show_new/#{@lesson_1_3.id}"

    grade_link  = find('a.module-title-grades:not(.active)')
    assert_equal grade_link[:href], "/unbounded/show_new/#{@grade.id}"
    assert_equal grade_link.text,   'Grade 1'

    module_link = find('a.module-title-module:not(.active)')
    assert_equal module_link[:href], "/unbounded/show_new/#{@module1.id}"
    assert_equal module_link.text,   'Module 1'    

    unit_link = find('a.unit-title:not(.active)')
    assert_equal unit_link[:href], "/unbounded/show_new/#{@unit1.id}"
    assert_equal unit_link.text,   'Unit 1'    

    current_lesson_link = find('div.lesson.lesson-active a:not(.disabled)')
    assert_equal current_lesson_link[:href], "/unbounded/show_new/#{@lesson_1_3.id}"

    other_lesson_links = all('div.lesson:not(.lesson-active) a:not(.disabled)')
    assert_equal other_lesson_links.size, 2
    assert_equal other_lesson_links[0][:href], "/unbounded/show_new/#{@lesson_1_1.id}"
    assert_equal other_lesson_links[1][:href], "/unbounded/show_new/#{@lesson_1_2.id}"
  end

  def test_module_navigation
    # Module 1
    visit "/unbounded/show_new/#{@lesson_1_1.id}"
    within '.lesson-nav' do
      within '.nav-module-up' do
        assert has_no_selector?('a')
        assert has_no_text?('Previous MODULE')
      end

      within '.nav-module-down' do
        assert has_selector?("a[href='/unbounded/show_new/#{@module2.id}']")
        assert has_text?('Next MODULE')
      end
    end

    # Module 2
    visit "/unbounded/show_new/#{@lesson_2_1.id}"
    within '.lesson-nav' do
      within '.nav-module-up' do
        assert has_selector?("a[href='/unbounded/show_new/#{@module1.id}']")
        assert has_text?('Previous MODULE')
      end

      within '.nav-module-down' do
        assert has_selector?("a[href='/unbounded/show_new/#{@module3.id}']")
        assert has_text?('Next MODULE')
      end
    end

    # Module 3
    visit "/unbounded/show_new/#{@lesson_3_1.id}"
    within '.lesson-nav' do
      within '.nav-module-up' do
        assert has_selector?("a[href='/unbounded/show_new/#{@module2.id}']")
        assert has_text?('Previous MODULE')
      end

      within '.nav-module-down' do
        assert has_no_selector?('a')
        assert has_no_text?('Next MODULE')
      end
    end
  end

  def test_lesson_navigation
    # Lesson 1
    visit "/unbounded/show_new/#{@lesson_1_1.id}"
    within '.lesson-nav' do
      within '.nav-lesson-left' do
        assert has_no_selector?('a')
        assert has_no_text?('Previous LESSON')
      end

      within '.nav-lesson-right' do
        assert has_selector?("a[href='/unbounded/show_new/#{@lesson_1_2.id}']")
        assert has_text?('Next LESSON')
      end
    end

    # Lesson 2
    visit "/unbounded/show_new/#{@lesson_1_2.id}"
    within '.lesson-nav' do
      within '.nav-lesson-left' do
        assert has_selector?("a[href='/unbounded/show_new/#{@lesson_1_1.id}']")
        assert has_text?('Previous LESSON')
      end

      within '.nav-lesson-right' do
        assert has_selector?("a[href='/unbounded/show_new/#{@lesson_1_3.id}']")
        assert has_text?('Next LESSON')
      end
    end

    # Lesson 3
    visit "/unbounded/show_new/#{@lesson_1_3.id}"
    within '.lesson-nav' do
      within '.nav-lesson-left' do
        assert has_selector?("a[href='/unbounded/show_new/#{@lesson_1_2.id}']")
        assert has_text?('Previous LESSON')
      end

      within '.nav-lesson-right' do
        assert has_no_selector?('a')
        assert has_no_text?('Next LESSON')
      end
    end
  end
end
