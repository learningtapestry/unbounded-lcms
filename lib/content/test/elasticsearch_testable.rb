module Content
  module Test
    module ElasticsearchTestable
      def self.included(base)
        base.extend(ElasticsearchTestable::ClassMethods)
        base.include(ElasticsearchTestable::InstanceMethods)

        base.instance_eval do
          cattr_accessor :elasticsearch_prefix
          self.elasticsearch_prefix = 'test'
        end
      end

      module ClassMethods
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

        def prefix_index_names
          prefix = elasticsearch_prefix
          searchables.each do |searchable|
            unless searchable.index_name.start_with?("#{prefix}_")
              searchable.index_name("#{prefix}_#{searchable.index_name}")
            end
          end
        end

        def restore_original_index_names
          searchables.each do |searchable|
            searchable.restore_original_index_name
          end
        end

        def searchables
          Models::Searchable.searchables
        end
      end

      module InstanceMethods
        def setup
          super

          skip unless self.class.check_elasticsearch
        end
      end
    end
  end
end
