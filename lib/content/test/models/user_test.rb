require 'test_helper'
require 'content/models'

module Content
  module Test
    class UserTest < ContentTestBase
      def test_add_role
        @mark.add_role(@unbounded, @janitor)
        @mark.save
        assert_includes @mark.roles(@unbounded), @janitor
      end

      def test_remove_role
        @mark.add_role(@unbounded, @janitor)
        @mark.save
        @mark.remove_role(@unbounded, @janitor)
        refute_includes @mark.roles(@unbounded), @janitor
      end

      def test_add_to_organization
        @mark.add_to_organization(@easol)
        @mark.save
        assert_includes @mark.organizations, @easol
      end

      def test_remove_from_organization
        @mark.add_to_organization(@easol)
        @mark.save
        @mark.remove_from_organization(@easol)
        refute_includes @mark.organizations, @easol
      end

      def test_has_role
        @mark.add_role(@unbounded, @janitor)
        @mark.save
        assert @mark.has_role?(@unbounded, @janitor)
      end

      def test_has_role_hasnt
        @mark.add_role(@unbounded, @janitor)
        @mark.save
        refute @mark.has_role?(@unbounded, @admin)
      end

      def setup
        super
        @janitor = roles(:janitor)
        @admin = roles(:admin)
        @mark = users(:mark)
        @unbounded = organizations(:unbounded)
        @easol = organizations(:easol)
        
        @mark.add_to_organization(@unbounded)
        @mark.save
      end
    end
  end
end
