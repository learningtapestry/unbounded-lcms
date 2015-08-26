require 'elasticsearch/model'
require 'content/search/esbuilder'

module Content
  module Searchable

    def self.searchables
      @@searchables ||= []
    end

    def self.included(base)
      searchables << base unless searchables.include?(base)

      base.include(Elasticsearch::Model)

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
        search_def = Search::Esbuilder.build(&blk).to_hash
        search(search_def, options)
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
