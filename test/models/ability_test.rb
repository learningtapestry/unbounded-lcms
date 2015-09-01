require 'test_helper'

class AbilityTest < Content::Test::ContentTestBase
  def test_admin_can_manage_lobjects
    @mark.add_role(@unbounded, @admin)
    ability = Ability.new(@mark)
    assert ability.can?(:manage, Lobject.new(organization: @unbounded))
  end

  def test_admin_cant_manage_lobjects
    ability = Ability.new(@mark)
    refute ability.can?(:manage, Lobject.new(organization: @unbounded))
  end

  def setup
    @admin = roles(:admin)
    @mark = users(:mark)
    @unbounded = organizations(:unbounded)
    @easol = organizations(:easol)
    users(:mark).add_to_organization(@unbounded)
  end
end
