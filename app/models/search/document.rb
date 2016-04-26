module Search
  class Document
    include Virtus.model

    attribute :model_type
    attribute :title, String
    attribute :description, String
    attribute :misc, String

    def self.repository
      @@repository ||= Elasticsearch::Persistence::Repository.new do
        index :"unbounded_#{Rails.env}"

        type :documents

        klass Search::Document

        settings index: Search::index_settings do
          mappings dynamic: 'false' do
            indexes :model_type
            indexes :title,       **Search::ngrams_multi_field(:title)
            indexes :description, **Search::ngrams_multi_field(:description)
            indexes :misc,        **Search::ngrams_multi_field(:description)
          end
        end
      end
    end

    def repository
      self.class.repository
    end

    def self.build_from(model)
      # initialize from AR models
      self.new
    end

    def index
      repository.save self
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
                { match: { 'title.full'    => {query: term, type: 'phrase', boost: 10} } },
                { match: { 'title.partial' => {query: term, boost: 10} } },

                { match: { 'description.full'    => {query: term, type: 'phrase', boost: 1} } },
                { match: { 'description.partial' => {query: term, boost: 1} } },
              ]
            }
          },
          size: limit,
          from: (page - 1) * limit
        }
      end
    end

    def self.search(term, options={})
      repository.search build_query(term, options)
    end
  end
end
