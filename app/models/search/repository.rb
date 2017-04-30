module Search
  def self.ngrams_multi_field(prop)
    {
      type: 'string', fields: {
        :full    => {type: 'string', analyzer: 'full_str'},
        :partial => {type: 'string', analyzer: 'partial_str'},
        :key     => {type: 'string', analyzer: 'keyword_str'}
      }
    }
  end

  def self.index_settings
    {
      analysis: {
        filter: {
          str_ngrams: {type: "nGram", min_gram: 3, max_gram: 10},
          stop_en:    {type: "stop", stopwords: "_english_"},
        },
        analyzer: {
          keyword_str: {
            filter:["lowercase"],
            type: "custom",
            tokenizer: "keyword",
          },
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

  class Repository
    include Elasticsearch::Persistence::Repository

    client Elasticsearch::Client.new(host: ENV['ELASTICSEARCH_ADDRESS'])

    index  :"unbounded_documents_#{Rails.env}"

    type :documents

    klass ::Search::Document

    settings index: ::Search.index_settings do
      mappings dynamic: 'false' do
        indexes :model_type,    type: 'string', index: 'not_analyzed'  # ActiveRecord model => resource | content_guide
        indexes :model_id,      type: 'string', index: 'not_analyzed'
        indexes :title,         **::Search.ngrams_multi_field(:title)
        indexes :teaser,        **::Search.ngrams_multi_field(:teaser)
        indexes :description,   **::Search.ngrams_multi_field(:description)
        indexes :doc_type,      type: 'string', index: 'not_analyzed'  #  module | unit | lesson | video | etc
        indexes :grade,         type: 'string', index: 'not_analyzed'
        indexes :subject,       type: 'string'
        indexes :tag_authors,   **::Search.ngrams_multi_field(:tag_authors)
        indexes :tag_texts,     **::Search.ngrams_multi_field(:tag_texts)
        indexes :tag_keywords,  **::Search.ngrams_multi_field(:tag_keywords)
        indexes :tag_standards, type: 'string', analyzer: 'keyword_str'
        indexes :position,      type: 'string', index: 'not_analyzed'
        indexes :breadcrumbs,   type: 'string', index: 'not_analyzed'
      end
    end

    def all_query(options)
      limit = options.fetch(:per_page, 20)
      page = options.fetch(:page, 1)

      query = {
        query: {
          bool: {
            must: { match_all: {} },
            filter: []
          }
        },
        sort: [
          { subject: 'asc' },
          { position: 'asc' },
          { 'title.key' => 'asc' },
        ],
        size: limit,
        from: (page - 1) * limit
      }

      apply_filters(query, options)
    end

    def fts_query(term, options)
      if term.respond_to?(:to_hash)
        term

      else
        limit = options.fetch(:per_page, 20)
        page = options.fetch(:page, 1)
        term = replace_synonyms term.downcase

        query = {
          min_score: 0.20,
          query: {
            bool: {
              should: [
                { match: { 'title.full'     => {query: term, boost: 3, type: 'phrase'} } },
                { match: { 'title.partial'  => {query: term, boost: 0.5} } },

                { match: { 'teaser.full'    => {query: term, boost: 4, type: 'phrase'} } },

                { match: { 'tag_authors.full'    => {query: term, boost: 4} } },

                { match: { 'tag_texts.full'    => {query: term, boost: 4} } },

                { match: { 'tag_keywords.full'    => {query: term, boost: 4} } },
              ],
              filter: []
            }
          },
          size: limit,
          from: (page - 1) * limit
        }

        apply_filters(query, options)
      end
    end

    def standards_query(term, options)
      if term.respond_to?(:to_hash)
        term

      else
        limit = options.fetch(:per_page, 20)
        page = options.fetch(:page, 1)

        query = {
          query: {
            bool: {
              filter: [],
              should: [
                { term: {tag_standards: term} },
                { match_phrase_prefix: {tag_standards: {query: term}} }
              ],
              minimum_should_match: 1,
            }
          },
          size: limit,
          from: (page - 1) * limit
        }

        apply_filters query, options
      end
    end

    def apply_filters(query, options)
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

    def accepted_filters
      [:model_type, :subject, :grade, :doc_type]
    end

    def replace_synonyms(term)
      @@synonyms ||= {
        'text sets'   => 'text set',
        'expert pack' => 'expert packs',
      }
      @@synonyms[term] || term
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
