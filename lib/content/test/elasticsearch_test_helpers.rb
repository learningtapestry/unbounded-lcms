module Content
  module Test
    module ElasticsearchTestHelpers
      def check_elasticsearch
        begin
          Elasticsearch::Model.client.perform_request('GET', '_cluster/health')
          true
        rescue StandardError
          false
        end
      end

      def load_searchable_fixtures
        create_indeces

        bulk_data = []
        Dir[File.join(TEST_PATH, 'fixtures', 'elasticsearch', '*.json')].each do |f|
          File.readlines(f).each do |line|
            bulk_data << JSON.load(line)
          end
        end

        Elasticsearch::Model.client.bulk(body: bulk_data)
        
        searchables.each do |searchable|
          searchable.__elasticsearch__.refresh_index!
        end
      end

      def create_indeces
        searchables.each do |searchable|
          searchable.__elasticsearch__.create_index!
        end
      end

      def prefix_index_names(prefix = 'test')
        searchables.each do |searchable|
          unless searchable.index_name.start_with?("#{prefix}_")
            searchable.index_name("#{prefix}_#{searchable.index_name}")
          end
        end
      end

      def searchables
        Models::Searchable.searchables
      end
    end
  end
end
