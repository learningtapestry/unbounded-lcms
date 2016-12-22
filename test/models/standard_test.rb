require 'test_helper'

class StandardTest < ActiveSupport::TestCase
  def setup
    @standard = Standard.first
    StandardEmphasis.create(standard: @standard, grade: nil, emphasis: 'a')
    StandardEmphasis.create(standard: @standard, grade: 'grade 10', emphasis: 'm')
  end

  def test_has_many_emphases
    assert @standard.standard_emphases.count == 2
  end

  def test_emphasis_leverages_the_grade
    assert @standard.emphasis('grade 10') == 'm'
    assert @standard.emphasis == 'a'
  end

  def test_bilingual_scope
    Standard.create(name: 'Bilingual Std',
                    grades:['grade 11'],
                    subject: 'ela',
                    alt_names: ['bilingual-std'],
                    is_language_progression_standard: true)
    assert Standard.bilingual.count == 1
  end

  def test_search_by_name
    Standard.create(name: 'Test Std',
                    grades:['grade 10'],
                    subject: 'ela',
                    alt_names: ['test-std', 'a-synonym'])

    # search on name
    assert Standard.search_by_name('ccss.math').count == 4

    # search on synonyms
    assert Standard.search_by_name('a-synonym').count == 1
  end
end
