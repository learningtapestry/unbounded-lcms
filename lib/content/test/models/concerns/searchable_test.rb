require 'test_helper'
require 'content/models'

module Content
  module Test
    class SearchableTest < ElasticsearchTestBase
      def test_not_indexed
        lobject = Models::Lobject.create(indexed_at: nil)
        assert_includes Models::Lobject.not_indexed, lobject
      end

      def test_indexed
        lobject = Models::Lobject.create(indexed_at: Time.now)
        assert_equal [lobject], Models::Lobject.indexed
      end

      def test_index_document
        lobject = Models::Lobject.new
        lobject.lobject_descriptions << Models::LobjectDescription.new(description: 'Math')
        lobject.save

        lobject.index_document; Models::Lobject.__elasticsearch__.refresh_index!

        search = Models::Lobject.dsl_search do
          query { match '_id' => lobject.id }
        end

        assert_equal search.results.first.id.to_i, lobject.id
      end

      def test_delete_document
        lobject = Models::Lobject.new
        lobject.lobject_descriptions << Models::LobjectDescription.new(description: 'Math')
        lobject.save

        lobject.index_document; Models::Lobject.__elasticsearch__.refresh_index!
        lobject.delete_document; Models::Lobject.__elasticsearch__.refresh_index!

        search = Models::Lobject.dsl_search do
          query { match '_id' => lobject.id }
        end

        assert_empty search.results
      end

      def test_as_indexed_json_ignores_indexed_at
        lobject = Models::Lobject.new
        lobject.lobject_descriptions << Models::LobjectDescription.new(description: 'Math')
        lobject.save

        lobject.index_document; Models::Lobject.__elasticsearch__.refresh_index!

        search = Models::Lobject.dsl_search do
          query { match '_id' => lobject.id }
        end

        assert_nil search.results.first['indexed_at']
      end

      def test_update_index_settings
        update_settings = {
          :analysis => {
            :analyzer => {
              :test_analyzer => { 
                :type => "custom",
                :tokenizer => "standard",
                :filter => ["standard"]
              }
            }
          }
        }
        Models::Lobject.update_index_settings(update_settings); sleep 1

        settings = Models::Lobject.get_index_settings
        assert settings[Models::Lobject.index_name]['settings']['index']['analysis']['analyzer'].has_key?('test_analyzer')

        Models::Lobject.__elasticsearch__.create_index! force: true
      end

      def test_update_index_synonyms
        Models::Lobject.update_index_synonyms(['test', 'synonym']); sleep 1
        assert_equal ['test', 'synonym'], Models::Lobject.get_index_synonyms

        Models::Lobject.__elasticsearch__.create_index! force: true
      end

      def setup
        super
        assert Models::Lobject.included_modules.include?(Models::Searchable) # Sanity check
      end
    end
  end
end
