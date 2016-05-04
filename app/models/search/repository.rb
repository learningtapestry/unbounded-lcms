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
        indexes :model_type,  type: 'string', index: 'not_analyzed'  # ActiveRecord model => resource | content_guide
        indexes :model_id,    type: 'string', index: 'not_analyzed'
        indexes :title,       **::Search.ngrams_multi_field(:title)
        indexes :teaser,      **::Search.ngrams_multi_field(:teaser)
        indexes :description, **::Search.ngrams_multi_field(:description)
        indexes :misc,        **::Search.ngrams_multi_field(:description)
        indexes :doc_type,    type: 'string', index: 'not_analyzed'  #  module | unit | lesson | video | etc
        indexes :grade,       type: 'string', index: 'not_analyzed'
        indexes :subject,     type: 'string'
      end
    end

    def build_query(term, options)
      if term.respond_to?(:to_hash)
        term

      else
        limit = options.fetch(:per_page, 10)
        page = options.fetch(:page, 1)
        model_type = options[:model_type]

        query = {
          query: {
            bool: {
              should: [
                { match: { 'title.full'     => {query: term, type: 'phrase', boost: 5} } },
                { match: { 'title.partial'  => {query: term, boost: 5} } },

                { match: { 'teaser.full'    => {query: term, type: 'phrase', boost: 1} } },
                { match: { 'teaser.partial' => {query: term, boost: 1} } },

                # { match: { 'description.full'     => {query: term, type: 'phrase', boost: 1} } },
                # { match: { 'description.partial'  => {query: term, boost: 1} } },
              ],
              filter: []
            }
          },
          size: limit,
          from: (page - 1) * limit
        }

        # filters
        accepted_filters.each do |filter|
          if options[filter]
            if options[filter].is_a? Array
              filter_term = { terms: { filter => options[filter] } }
            else
              filter_term = { match: { filter => {query: options[filter]} } }
            end
            query[:query][:bool][:filter] << filter_term
          end
        end

        query
      end
    end

    def accepted_filters
      [:model_type, :subject, :grade, :doc_type]
    end

    def index_exists?
      begin
        client.indices.exists? index: index
      rescue Faraday::ConnectionFailed;
        false
      end
    end

    def empty_response
      Elasticsearch::Persistence::Repository::Response::Results.new(self, {hits: {total: 0, max_score: nil, hits:[]}})
    end
  end
end
