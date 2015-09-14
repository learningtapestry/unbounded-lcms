require 'content/models'
require 'content/search'

module Unbounded
  class LobjectFacets
    attr_reader :operation, :facets

    def initialize(params)
      aggregation_paths = {
        'sources.engageny' => 'sources.engageny.active',
        'resource_types' => 'resource_types.name.raw',
        'grades' => 'grades.grade.raw',
        'topics' => 'topics.name.raw',
        'subjects' => 'subjects.name.raw',
        'alignments' => 'alignments.name.raw'
      }

      aggs_def = Content::Search::Esbuilder.build do
        aggregation_paths.each do |p, f|
          aggregation p do
            nested do
              path p
              aggregation p do
                terms do
                  field f
                  size 0
                end
              end
            end
          end
        end
      end.to_hash[:aggregations]

      filters_def = Content::Search::Esbuilder.build do
        filter do
          bool do
            module_call LobjectRestrictions, :restrict_lobjects
          end
        end
      end.to_hash[:filter]

      search_definition = {
        aggregations: {
          facets_agg: {
            aggregations: aggs_def,
            filter: filters_def
          }
        }
      }

      Rails.logger.debug("Constructed Elasticsearch search definition: #{search_definition.to_json}")

      @operation = Content::Models::Lobject.search(search_definition, search_type: :count)
      @facets = Hash.new { |h, k| h[k] = {} }

      aggregation_paths.keys.each do |path|
        operation.response.aggregations[:facets_agg][path][path].buckets.each do |bucket|
          @facets[path][bucket['key']] = bucket['doc_count']
        end
      end
    end
  end
end
