require 'test_helper'
require 'content/models'

module Content
  module Test
    class RoleTest < ContentTestBase
      def test_named
        assert_equal roles(:admin), Models::Role.named(:admin)
      end
    end
  end
end
