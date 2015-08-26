require 'content/test/test_helper'
require 'content/models'

module Content
  module Test
    class SearchableTest < ElasticsearchTestBase
      def test_not_indexed
        lobject = Lobject.create(indexed_at: nil)
        assert_equal [lobject], Lobject.not_indexed
      end

      def test_indexed
        lobject = Lobject.create(indexed_at: Time.now)
        assert_equal [lobject], Lobject.indexed
      end

      def test_index_document
        lobject = Lobject.new
        lobject.lobject_descriptions << LobjectDescription.new(description: 'Math')
        lobject.save

        lobject.index_document; Lobject.__elasticsearch__.refresh_index!

        search = Lobject.dsl_search do
          query { match '_id' => lobject.id }
        end

        assert_equal search.results.first.id.to_i, lobject.id
      end

      def test_delete_document
        lobject = Lobject.new
        lobject.lobject_descriptions << LobjectDescription.new(description: 'Math')
        lobject.save

        lobject.index_document; Lobject.__elasticsearch__.refresh_index!
        lobject.delete_document; Lobject.__elasticsearch__.refresh_index!

        search = Lobject.dsl_search do
          query { match '_id' => lobject.id }
        end

        assert_empty search.results
      end

      def test_as_indexed_json_ignores_indexed_at
        lobject = Lobject.new
        lobject.lobject_descriptions << LobjectDescription.new(description: 'Math')
        lobject.save

        lobject.index_document; Lobject.__elasticsearch__.refresh_index!

        search = Lobject.dsl_search do
          query { match '_id' => lobject.id }
        end

        assert_nil search.results.first['indexed_at']
      end

      def setup
        super
        assert Lobject.included_modules.include?(Searchable) # Sanity check
      end
    end
  end
end
