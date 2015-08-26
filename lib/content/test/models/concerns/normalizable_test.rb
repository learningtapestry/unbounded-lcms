require 'content/test/test_helper'
require 'content/models'

module Content
  module Test
    class NormalizableTest < ContentTestBase
      def test_normalize_attr_singleton
        assert_equal 'english', Language.normalize_name('   eNgLiSh   ')
      end

      def test_normalize_attr_instance
        lang = Language.new
        lang.name = '   eNgLiSh   '
        assert_equal 'english', lang.name
      end

      def setup
        super
        assert Language.included_modules.include?(Normalizable) # Sanity check
      end
    end
  end
end
