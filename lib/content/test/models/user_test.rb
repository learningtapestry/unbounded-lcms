require 'test_helper'
require 'content/models'

module Content
  module Test
    class UserTest < ContentTestBase
      def test_roles
        @mark.roles(@unbounded, [@janitor, @admin])
        assert_equal @mark.roles(@unbounded).to_a, [@janitor, @admin]
      end

      def test_add_role
        @mark.add_role(@unbounded, @janitor)
        assert_includes @mark.roles(@unbounded), @janitor
      end

      def test_remove_role
        @mark.add_role(@unbounded, @janitor)
        @mark.remove_role(@unbounded, @janitor)
        refute_includes @mark.roles(@unbounded), @janitor
      end

      def test_add_to_organization
        @mark.add_to_organization(@easol)
        assert_includes(@mark.organizations, @easol)
      end

      def test_remove_from_organization
        @mark.add_to_organization(@easol)
        @mark.remove_from_organization(@easol)
        refute_includes(@mark.organizations, @easol)
      end

      def test_has_role
        @mark.add_role(@unbounded, @janitor)
        assert @mark.has_role?(@unbounded, @janitor)
      end

      def test_has_role_hasnt
        @mark.add_role(@unbounded, @janitor)
        refute @mark.has_role?(@unbounded, @admin)
      end

      def setup
        super
        @janitor = roles(:janitor)
        @admin = roles(:admin)
        @mark = users(:mark)
        @unbounded = organizations(:unbounded)
        @easol = organizations(:easol)
        users(:mark).add_to_organization(@unbounded)
      end
    end
  end
end
