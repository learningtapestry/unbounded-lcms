require 'elasticsearch/model'

module Search
  def ngrams_multi_field(prop)
    {
      type: 'multi_field', fields: {
        prop     =>    {type: 'string'},
        :full    =>    {type: 'string', analyzer: 'full_str'},
        :partial => {type: 'string', analyzer: 'partial_str'}
      }
    }
  end

  def index_settings
    {
      index: {
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
    }
  end

  module_function :ngrams_multi_field, :index_settings

  module ResourcesSearch
    def self.included(base)
      base.class_eval do

        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        settings index: Search::index_settings do
          mappings do
            indexes :title,       **Search::ngrams_multi_field(:title)
            indexes :short_title, **Search::ngrams_multi_field(:short_title)
            indexes :subtitle,    **Search::ngrams_multi_field(:subtitle)
            indexes :description, **Search::ngrams_multi_field(:description)
          end
        end

      end
    end
  end
end
