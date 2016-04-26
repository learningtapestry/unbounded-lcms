require 'elasticsearch/model'

module Search
  module DocumentsSearch
    module_function

    def build_query(term, options)
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

                # { match: { 'description.full'    => {query: term, type: 'phrase', boost: 1} } },
                # { match: { 'description.partial' => {query: term, boost: 1} } },
              ]
            }
          },
          size: limit,
          from: (page - 1) * limit
        }
      end
    end

    def search(term, models=nil, options={})
      models ||= [ ContentGuide, Resource ]
      query = build_query(term, options)
      Elasticsearch::Model.search(query, models)
    end

  end
end
