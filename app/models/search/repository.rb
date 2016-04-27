module Search
  def ngrams_multi_field(prop)
    {
      type: 'multi_field', fields: {
        prop     => {type: 'string'},
        :full    => {type: 'string', analyzer: 'full_str'},
        :partial => {type: 'string', analyzer: 'partial_str'}
      }
    }
  end

  def index_settings
    {
      analysis: {
        filter: {
          str_ngrams: {type: "nGram", min_gram: 2, max_gram: 10},
          stop_en:    {type: "stop", stopwords: "_english_"},
        },
        analyzer: {
          full_str: {
            filter: ["standard", "lowercase", "stop_en", "asciifolding"],
            type: "custom",
            tokenizer: "standard",
          },
          partial_str: {
            filter: ["standard", "lowercase", "stop_en", "asciifolding", "str_ngrams"],
            type: "custom",
            tokenizer: "standard",
          }
        }
      }
    }
  end

  module_function :ngrams_multi_field, :index_settings

  class Repository
    include Elasticsearch::Persistence::Repository

    client Elasticsearch::Client.new(host: ENV['ELASTICSEARCH_ADDRESS'])

    index  options[:index] || :"unbounded_#{Rails.env}"

    type :documents

    klass ::Search::Document

    settings index: ::Search.index_settings do
      mappings dynamic: 'false' do
        indexes :model_type,  type: 'string', index: 'not_analyzed'
        indexes :model_id,    type: 'string', index: 'not_analyzed'
        indexes :title,       **::Search.ngrams_multi_field(:title)
        indexes :description, **::Search.ngrams_multi_field(:description)
        indexes :misc,        **::Search.ngrams_multi_field(:description)
      end
    end

    def build_query(term, options)
      if term.respond_to?(:to_hash)
        term

      else
        limit = options.fetch(:limit, 10)
        page = options.fetch(:page, 1)
        model_type = options.delete(:model_type)
        query = {
          query: {
            bool: {
              should: [
                { match: { 'title.full'          => {query: term, type: 'phrase', boost: 10} } },
                { match: { 'title.partial'       => {query: term, boost: 10} } },

                { match: { 'description.full'    => {query: term, type: 'phrase', boost: 1} } },
                { match: { 'description.partial' => {query: term, boost: 1} } },

                { match: { 'misc.full'           => {query: term, type: 'phrase', boost: 1} } },
                { match: { 'misc.partial'        => {query: term, boost: 1} } },
              ]
            }
          },
          size: limit,
          from: (page - 1) * limit
        }
        query[:query][:bool][:must] = [{ match: { model_type: model_type } }] if model_type
        query
      end
    end

    def index_exists?
      client.indices.exists? index: index
    end
  end
end
