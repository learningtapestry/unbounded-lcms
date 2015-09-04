require 'test_helper'
require 'content/models'

module Content
  module Test
    class CanonicableTest < ContentTestBase

      def test_parent
        assert_equal @en, @en_US.parent
      end

      def test_children
        assert_equal @en_US, @en.children.first
      end

      def test_chain
        assert_equal [@en, @en_US], @en_US.chain
      end

      def test_canonical_from_child
        assert_equal @en, @en_US.canonical
      end

      def test_canonical_from_parent
        assert_equal @en, @en.canonical
      end

      def test_canonicals
        refute_includes Models::Language.canonicals, languages(:en_US)
      end

      def test_find_or_create_canonical
        assert_equal @en, Models::Language.find_or_create_canonical(name: Models::Language.normalize_name('en_US'))
      end

      def setup
        super
        assert Models::Language.included_modules.include?(Models::Canonicable) # Sanity check
        @en = languages(:en)
        @en_US = languages(:en_US)
      end
    end
  end
end
