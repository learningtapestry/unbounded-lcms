require 'content/search/esbuilder'

module Content
  module Search
    module Esqueries
      def es_filtered_facets(options = {})
        selected_filters = (options[:filters] || {}).dup
        selected_filters['_all'] = options[:query]
        selected_facets = options[:facets]

        definition = Esbuilder.build { aggregation(:facets_agg) { } }.to_hash

        unless selected_facets.keys.empty?
          aggs_def = es_terms_aggs(fields: selected_facets).to_hash[:aggregations]
          definition[:aggregations][:facets_agg][:aggregations] = aggs_def
        end

        filters_def = es_filters(selected_filters).to_hash[:filter]
        definition[:aggregations][:facets_agg][:filter] = filters_def

        definition
      end

      def es_top_hits(options = {})
        definition = es_terms_aggs(
          fields: { options[:path] => options[:field] },
          top_hits: true,
          pattern: options[:pattern]
        )

        definition
      end

      def es_filters(paths)
        _self = self

        Esbuilder.build do
          filter do
            bool do
              paths.each do |_path, _val|
                if _val.is_a?(Hash)
                  must do
                    nested do
                      path _path
                      filter do
                        bool do
                          _val.each do |_term, _termval|
                            must { term _term => _termval }
                          end
                        end
                      end
                    end
                  end
                elsif _val.is_a?(String)
                  must { term _path => _val }
                end
              end

              must { term 'hidden' => false }

              _self.restrict_results(self)
            end
          end
        end
      end

      def es_terms_aggs(options)
        fields = options[:fields]
        top_hits = options[:top_hits] || false
        pattern = ".*#{Regexp.quote(options[:pattern])}.*" if options[:pattern]

        Esbuilder.build do
          fields.each do |_path, _field|
            aggregation _path do
              nested do
                path _path

                aggregation _path do
                  terms do
                    field _field
                    size 0

                    if pattern
                      include pattern: pattern, flags: 'CASE_INSENSITIVE'
                    end

                    if top_hits
                      aggregation :top_hits do
                        top_hits({ size: 1, _source: { exclude: [ 'id', 'full' ] } })
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      def es_query(options = {})
        _limit = options[:limit] || 100
        _page = options[:page] || 1
        _filters = options[:filters] || {}
        _query = options[:query]
        _self = self

        definition = Esbuilder.build do
          size _limit
          from (_page - 1) * _limit

          query do
            filtered do
              if _query
                query do
                  bool do
                    should { match 'title' => { query: _query, boost: 2 } }
                    should { match 'description' => { query: _query, boost: 2 } }
                    should { match '_all' => _query }
                  end
                end
              end
            end
          end
        end.to_hash

        definition[:query][:filtered][:filter] = es_filters(_filters).to_hash[:filter]

        definition
      end
    end
  end
end
