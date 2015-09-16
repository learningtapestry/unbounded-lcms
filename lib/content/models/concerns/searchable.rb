require 'elasticsearch/model'
require 'content/search'

module Content
  module Models
    module Searchable

      def self.searchables
        @@searchables ||= []
      end

      def self.included(base)
        searchables << base unless searchables.include?(base)

        base.include(Elasticsearch::Model)

        base.instance_eval do
          @original_index_name = index_name
        end

        base.class_eval do 
          scope :indexed, -> { where.not(indexed_at: nil) }
          scope :not_indexed, -> { where(indexed_at: nil) }
        end

        base.extend(ClassMethods)
      end

      module ClassMethods
        def index!(options = {})
          __elasticsearch__.create_index!

          options = { batch_size: 100 }.merge(options)
          import(options) do |response|
            ids = Array.wrap(response['items']).map { |item| item['index']['_id'] }
            where(id: ids).update_all(indexed_at: Time.now)
            yield response if block_given?
          end
        end

        def dsl_search(options = {}, &blk)
          search_def = Content::Search::Esbuilder.build(&blk).to_hash
          search(search_def, options)
        end

        def restore_original_index_name
          index_name @original_index_name
        end

        def synonyms_filter_name
          "#{table_name}_synonyms_filter"
        end

        def get_index_settings
          __elasticsearch__.client.indices.get_settings(index: index_name)
        end

        def get_index_synonyms
          get_index_settings[index_name]['settings']['index']['analysis']['filter'][synonyms_filter_name]['synonyms']
        end

        def update_index_settings(new_settings = settings)
          __elasticsearch__.client.indices.close(index: index_name)
          __elasticsearch__.client.indices.put_settings(index: index_name, body: new_settings)
          __elasticsearch__.client.indices.open(index: index_name)
        end

        def update_index_synonyms(synonyms)
          if synonyms.empty?
            synonyms = ['']
          end

          new_settings = settings.to_hash.deep_merge(
            analysis: {
              filter: {
                synonyms_filter_name.to_sym => {
                  type: 'synonym',
                  synonyms: synonyms
                }
              }
            }
          )

          update_index_settings(new_settings)
        end
      end

      module Callbacks
        def self.included(base)
          base.class_eval do
            after_commit :index_document, on: [:create, :update]
            after_commit :delete_document, on: :destroy
          end
        end

        def index_document
          begin
            self.class.__elasticsearch__.create_index!
            __elasticsearch__.index_document
            update_column(:indexed_at, Time.now)
          rescue Faraday::ConnectionFailed; end
        end

        def delete_document
          begin
            __elasticsearch__.delete_document
          rescue Faraday::ConnectionFailed; end
        end

        def as_indexed_json(options = {})
          as_json(except: [:indexed_at])
        end
      end
    end
  end
end
