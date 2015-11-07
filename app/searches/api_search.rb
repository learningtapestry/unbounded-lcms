require 'content/models'
require 'content/search'

class ApiSearch
  attr_reader :operation, :results, :total_count

  def initialize(params)
    limit = params[:limit].try(:to_i) || 100
    page = params[:page].try(:to_i) || 1

    aggregation_paths = {
      'languages' => 'languages.name.raw',
      'identities' => 'identities.full.raw',
      'alignments' => 'alignments.name.raw',
      'resource_types' => 'resource_types.name.raw',
      'subjects' => 'subjects.name.raw',
      'grades' => 'grades.grade.raw'
    }

    param_paths = {
      'language' => 'languages',
      'publisher' => 'identities',
      'alignment' => 'alignments',
      'resource_type' => 'resource_types',
      'subject' => 'subjects',
      'grade' => 'grades'
    }

    include_aggs = aggregation_paths.except(*(param_paths.slice(*params.keys).values))

    search_definition = Content::Search::Esbuilder.build do
      size limit
      from (page - 1) * limit

      query do
        filtered do
          filter do
            bool do
              must { term 'hidden' => false }

              if params['language']
                must do
                  nested do
                    path 'languages'
                    filter do
                      term 'languages.name.raw' => params[:language]
                    end
                  end
                end
              end

              if params['publisher']
                must do
                  nested do
                    path 'identities'
                    filter do
                      bool do
                        must { term 'identities.name.raw' => params[:publisher] }
                        must { term 'identities.identity_type' => 'publisher' }
                      end
                    end
                  end
                end
              end

              if params['alignment']
                must do
                  nested do
                    path 'alignments'
                    filter do
                      term 'alignments.name.raw' => params[:alignment]
                    end
                  end
                end
              end

              if params['resource_type']
                must do
                  nested do
                    path 'resource_types'
                    filter do
                      term 'resource_types.name.raw' => params[:resource_type]
                    end
                  end
                end
              end

              if params['subject']
                must do
                  nested do
                    path 'subjects'
                    filter do
                      term 'subjects.name.raw' => params[:subject]
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
          elsif params[:title]
            query do
              match 'title' => params[:title]
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

                if p == 'identities'
                  include '.* publisher'
                end
              end
            end
          end
        end
      end
    end

    Rails.logger.debug("  Elasticsearch search definition: #{search_definition.to_json}")

    @operation = Content::Models::Lobject.search(search_definition)

    facets = Hash.new { |h, k| h[k] = {} }

    if operation.response[:aggregations]
      operation.response.aggregations.each do |path, agg|
        agg[path].buckets.each do |bucket|
          if path == 'identities'
            identity_id = bucket['key'].split.first.to_i
            identity = Content::Models::Identity.find(identity_id)
            facets['publishers'][identity.name] = bucket['doc_count']
          else
            facets[path][bucket['key']] = bucket['doc_count']
          end
        end
      end
    end

    @results = {
      aggregations: facets,
      results: operation.map(&:_source)
    }

    @total_count = operation.response[:hits][:total]
  end
end
