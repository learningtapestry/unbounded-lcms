require 'content/models'
require 'content/search'

module Unbounded
  class LobjectSearch
    include Content::Models

    attr_reader :operation, :facets, :results,
      :total_hits, :total_pages, :page, :limit

    def initialize(params)
      @limit = limit = params[:limit] = Integer(params[:limit]) rescue 100
      @page = page = (params[:page].try(:to_i) || 1)

      params = params.dup
      params[:standards].delete('all') rescue nil

      collection_ids =
        if (subject = params[:subject]).present?
          LobjectCollection.curriculum_maps_for(subject)
        else
          LobjectCollection.curriculum_maps
        end.map(&:id)

      standard_ids = params[:standard_ids].kind_of?(Array) ? params[:standard_ids].map(&:to_i) : []

      search_definition = Content::Search::Esbuilder.build do
        size limit
        from (page - 1) * limit

        query do
          function_score do
            functions << {
              script_score: {
                params: {
                  standard_ids: standard_ids
                },
                script: '_source.alignments.collect { it.id }.intersect(standard_ids).size()'
              }
            }

            query do
              filtered do
                filter do
                  bool do
                    apply LobjectRestrictions, :restrict_lobjects

                    must do
                      nested do
                        path 'collections'
                        filter do
                          terms 'collections.id' => collection_ids
                        end
                      end
                    end

                    if params[:grade_id].present?
                      must do
                        nested do
                          path 'grades'
                          filter do
                            term 'grades.id' => params[:grade_id]
                          end
                        end
                      end
                    end

                    if standard_ids.any?
                      must do
                        nested do
                          path 'alignments'
                          filter do
                            terms 'alignments.id' => standard_ids
                          end
                        end
                      end
                    end
                  end
                end

                if params[:query].present?
                  query do
                    bool do
                      should { match curriculum_title: { query: params[:query], boost: 4 } }
                      should { match 'description' => { query: params[:query], boost: 2 } }
                      should { match '_all' => params[:query] }
                    end
                  end
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
    end
  end
end
