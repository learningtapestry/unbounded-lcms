require 'content/search/esqueries'
require 'content/search/query_results'
require 'content/search/facets_results'

module Content
  module Search
    class SearchBase
      include Esqueries

      def browser_facets(options = {})
        es_options = options.dup
        es_options[:filters] = {}

        (options[:filters] || {}).each do |k, v|
          es_options[:filters][k] = { facet_fields[k] => v }
        end

        es_options[:facets] ||= facet_fields.except(*es_options[:filters].keys)

        facets(es_options)
      end

      def browser_query(options = {})
        filters = options[:filters] || {}

        es_options = options.dup
        es_options[:filters] = {}

        filters.each do |k, v|
          es_options[:filters][k] = { facet_fields[k] => v }
        end

        query(es_options)
      end

      def facets(options)
        filters = options[:filters] || {}
        
        definition = es_filtered_facets(options)
        response = Lobject.search(definition, search_type: :count).response
        facets_results = {}

        options[:facets].except(*filters.keys).keys.each do |facet_field|
          facets_results[facet_field] = {}
          response.aggregations.facets_agg[facet_field][facet_field].buckets.each do |b|
            facets_results[facet_field][b['key']] = b['doc_count']
          end
        end

        FacetsResults.new(
          filters: filters,
          facets: facets_results, 
          query: options[:query]
        )
      end

      def query(options)
        definition = es_query(options)
        search = Lobject.search(definition)

        QueryResults.new(
          query: options[:query], 
          results: search.map(&:_source),
          total_hits: search.response.hits.total.to_i
        )
      end

      def top_hits(options = {})
        path = options[:path]
        response = Lobject.search(es_top_hits(options), search_type: :count).response
        hits = []

        response.aggregations[path][path].buckets.each do |b|
          hit = b.top_hits.hits.hits.first._source
          hit['resource_count'] = b['doc_count']
          hits << hit
        end

        hits
      end
    end
  end
end
