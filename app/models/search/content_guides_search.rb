require 'elasticsearch/model'

module Search
  module ContentGuidesSearch
    def self.included(base)
      base.class_eval do

        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        settings index: Search::index_settings do
          mappings dynamic: 'false' do
            indexes :title,       **Search::ngrams_multi_field(:title)
            indexes :name,        **Search::ngrams_multi_field(:short_title)
            indexes :teaser,      **Search::ngrams_multi_field(:subtitle)
            indexes :description, **Search::ngrams_multi_field(:description)
            # indexes :content,     **Search::ngrams_multi_field(:description)
          end
        end

        def self.build_query(term, options)
          if term.respond_to?(:to_hash)
            term

          else
            limit = options.fetch(:limit, 10)
            page = options.fetch(:page, 1)
            {
              query: {
                bool: {
                  should: [
                    { match: { 'title.full'     => {query: term, type: 'phrase', boost: 5} } },
                    { match: { 'title.partial'  => {query: term, boost: 5} } },

                    { match: { 'name.full'      => {query: term, type: 'phrase', boost: 1} } },
                    { match: { 'name.partial'   => {query: term, boost: 1} } },

                    { match: { 'teaser.full'    => {query: term, type: 'phrase', boost: 2} } },
                    { match: { 'teaser.partial' => {query: term, boost: 2} } },

                    { match: { 'description.full'    => {query: term, type: 'phrase', boost: 1} } },
                    { match: { 'description.partial' => {query: term, boost: 1} } },

                    # { match: { 'content.full'    => {query: term, type: 'phrase', boost: 1} } },
                    # { match: { 'content.partial' => {query: term, boost: 1} } },
                  ]
                }
              },
              size: limit,
              from: (page - 1) * limit
            }
          end
        end

        def self.search(term, options={})
          __elasticsearch__.search build_query(term, options)
        end

      end
    end
  end
end
