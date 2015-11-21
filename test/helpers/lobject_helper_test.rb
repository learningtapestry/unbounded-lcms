require 'test_helper'

class LobjectHelperTest < ActionView::TestCase
  include Unbounded::LobjectHelper

  def test_unit_index
    assert_equal 1,   unit_index(:ela, 0)
    assert_equal 26,   unit_index(:ela, 25)
    assert_equal 27,  unit_index(:ela, 26)
    assert_equal 52,  unit_index(:ela, 51)
    assert_equal 53,  unit_index(:ela, 52)
    assert_equal 702,  unit_index(:ela, 701)
    assert_equal 703, unit_index(:ela, 702)

    assert_equal 'A',   unit_index(:math, 0)
    assert_equal 'Z',   unit_index(:math, 25)
    assert_equal 'AA',  unit_index(:math, 26)
    assert_equal 'AZ',  unit_index(:math, 51)
    assert_equal 'BA',  unit_index(:math, 52)
    assert_equal 'ZZ',  unit_index(:math, 701)
    assert_equal 'AAA', unit_index(:math, 702)
  end
end
