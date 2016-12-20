require 'test_helper'

class StandardTest < ActiveSupport::TestCase
  setup do
    @standard = Standard.first
    StandardEmphasis.create(standard: @standard, grade: nil, emphasis: 'a')
    StandardEmphasis.create(standard: @standard, grade: 'grade 10', emphasis: 'm')
  end

  test 'has_many_emphases' do
    assert @standard.standard_emphasis.count == 2
  end

  test 'emphasis leverages the grade' do
    assert @standard.emphasis('grade 10') == 'm'
    assert @standard.emphasis == 'a'
  end
end
