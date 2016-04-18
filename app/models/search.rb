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
end
