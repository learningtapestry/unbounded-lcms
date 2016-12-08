require 'test_helper'

class GenericPresenterTest < ActiveSupport::TestCase
  test 'grades_to_str' do
    resource = Resource.last
    resource.grade_list = [
      'prekindergarten', 'kindergarten',
      'grade 2',
      'grade 4',
      'grade 8', 'grade 9', 'grade 10',
      'grade 12'
    ].join(', ')
    resource.save!
    presenter = GenericPresenter.new(resource)
    assert_equal 'Grade PK-K, 2, 4, 8-10, 12', presenter.grades_to_str
  end

  test 'grades_to_str with single grade' do
    resource = Resource.last
    resource.grade_list = 'prekindergarten'
    resource.save!
    presenter = GenericPresenter.new(resource)
    assert_equal 'Grade PK', presenter.grades_to_str
  end
end
