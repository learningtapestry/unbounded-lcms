require 'test_helper'

class SearchFormTestCase < IntegrationDatabaseTestCase
  def setup
    super
    use_poltergeist
  end

  def test_curriculum_page
    visit '/curriculum'
    assert_equal ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'], all('.searchForm__gradeLabel').map(&:text)
    choose 'English Language Arts'
    assert_equal ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'], all('.searchForm__gradeLabel').map(&:text)
    choose 'Mathematics'
    assert_equal ['Algebra I', 'Geometry', 'Algebra II', 'Precalculus'], all('.searchForm__gradeLabel').map(&:text)

    visit '/curriculum/ela'
    assert_equal ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'], all('.searchForm__gradeLabel').map(&:text)

    visit '/curriculum/math'
    assert_equal ['Algebra I', 'Geometry', 'Algebra II', 'Precalculus'], all('.searchForm__gradeLabel').map(&:text)
  end

  def test_search_page
    visit '/search'
    assert_equal ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'], all('.searchForm__gradeLabel').map(&:text)
    choose 'English Language Arts'
    assert_equal ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'], all('.searchForm__gradeLabel').map(&:text)
    choose 'Mathematics'
    assert_equal ['Algebra I', 'Geometry', 'Algebra II', 'Precalculus'], all('.searchForm__gradeLabel').map(&:text)
    click_button 'Search'
    assert_equal ['Algebra I', 'Geometry', 'Algebra II', 'Precalculus'], all('.searchForm__gradeLabel').map(&:text)
    choose 'English Language Arts'
    assert_equal ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'], all('.searchForm__gradeLabel').map(&:text)
    click_button 'Search'
    assert_equal ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'], all('.searchForm__gradeLabel').map(&:text)
  end

  def test_per_page
    visit '/search'
    assert_equal '100', find('#limit').value
    assert_equal 100, all('.search-results h5').size

    select '50', from: 'limit'
    sleep 0.5
    assert_equal '50', find('#limit').value
    assert_equal 50, all('.search-results h5').size

    select '25', from: 'limit'
    sleep 0.5
    assert_equal '25', find('#limit').value
    assert_equal 25, all('.search-results h5').size

    select '100', from: 'limit'
    sleep 0.5
    assert_equal '100', find('#limit').value
    assert_equal 100, all('.search-results h5').size
  end
end
