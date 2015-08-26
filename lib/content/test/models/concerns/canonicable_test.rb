require 'content/test/test_helper'
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
        assert_equal [@en], Language.canonicals
      end

      def test_find_or_create_canonical
        assert_equal @en, Language.find_or_create_canonical(name: Language.normalize_name('en_US'))
      end

      def setup
        super
        assert Language.included_modules.include?(Canonicable) # Sanity check
        @en = Language.create(name: 'en')
        @en_US = Language.create(name: 'en_US', parent: @en)
      end
    end
  end
end
