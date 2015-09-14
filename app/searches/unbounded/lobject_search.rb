require 'content/models'
require 'content/search'

module Unbounded
  class LobjectSearch
    attr_reader :operation, :facets, :results,
      :total_hits, :total_pages, :page, :limit

    def initialize(params)
      @limit = limit = 100
      @page = page = (params[:page].try(:to_i) || 1)

      if params[:query] == ''
        params.delete(:query)
      end

      aggregation_paths = {
        'sources.engageny' => 'sources.engageny.active',
        'resource_types' => 'resource_types.name.raw',
        'grades' => 'grades.grade.raw',
        'topics' => 'topics.name.raw',
        'subjects' => 'subjects.name.raw',
        'alignments' => 'alignments.name.raw'
      }

      param_paths = {
        'active' => 'sources.engageny',
        'resource_type' => 'resource_types',
        'grade' => 'grades',
        'topic' => 'topics',
        'subject' => 'subjects',
        'alignment' => 'alignments'
      }

      include_aggs = aggregation_paths.except(*(param_paths.slice(*params.keys).values))

      search_definition = Content::Search::Esbuilder.build do
        size limit
        from (page - 1) * limit

        query do
          function_score do
            functions << {
              filter: {
                nested: {
                  path: 'collections',
                  filter: {
                    exists: {
                      field: 'collections.id'
                    }
                  }
                }
              },
              boost_factor: 2
            }

            query do
              filtered do
                filter do
                  bool do
                    module_call LobjectRestrictions, :restrict_lobjects
                    
                    if params[:active]
                      must do
                        nested do
                          path 'sources.engageny'
                          filter do
                            term 'sources.engageny.active' => params[:active]
                          end
                        end
                      end
                    end

                    if params[:resource_type]
                      must do
                        nested do
                          path 'resource_types'
                          filter do
                            term 'resource_types.name.raw' => params[:resource_type]
                          end
                        end
                      end
                    end

                    if params[:grade]
                      must do
                        nested do
                          path 'grades'
                          filter do
                            term 'grades.grade.raw' => params[:grade]
                          end
                        end
                      end
                    end

                    if params[:topic]
                      must do
                        nested do
                          path 'topics'
                          filter do
                            term 'topics.name.raw' => params[:topic]
                          end
                        end
                      end
                    end

                    if params[:subject]
                      must do
                        nested do
                          path 'subjects'
                          filter do
                            term 'subjects.name.raw' => params[:subject]
                          end
                        end
                      end
                    end

                    if params[:alignment]
                      must do
                        nested do
                          path 'alignments'
                          filter do
                            term 'alignments.name.raw' => params[:alignment]
                          end
                        end
                      end
                    end  
                  end
                end

                if params[:query]
                  query do
                    bool do
                      should { match 'title' => { query: params[:query], boost: 4 } }
                      should { match 'description' => { query: params[:query], boost: 2 } }
                      should { match '_all' => params[:query] }
                    end
                  end
                end
              end
            end
          end
        end

        include_aggs.each do |p, f|
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
      end

      Rails.logger.debug("  Elasticsearch search definition: #{search_definition.to_json}")

      @operation = Content::Models::Lobject.search(search_definition)
      @facets = Hash.new { |h, k| h[k] = {} }
      @results = operation.map(&:_source)
      @total_hits = operation.response.hits.total.to_i
      @total_pages = (@total_hits + (@limit-1))/@limit

      if operation.response[:aggregations]
        operation.response.aggregations.each do |path, agg|
          agg[path].buckets.each do |bucket|
            @facets[path][bucket['key']] = bucket['doc_count']
          end
        end
      end
    end
  end
end
