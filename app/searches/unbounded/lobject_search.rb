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

      params.delete(:grade) if params[:subject] == 'all'
      params.delete(:subject) if params[:subject] == 'all'
      params[:standards].delete('all') rescue nil

      collection_ids =
        if (subject = params[:subject]).present? && subject != 'all'
          LobjectCollection.curriculum_maps_for(subject)
        else
          LobjectCollection.curriculum_maps
        end.map(&:id)

      standard_ids = params[:standards].kind_of?(Array) ? params[:standards].map(&:to_i) : []

      search_definition = Content::Search::Esbuilder.build do
        size limit
        from (page - 1) * limit

        query do
          function_score do
            if standard_ids.any?
              functions << {
                script_score: {
                  params: {
                    ids: standard_ids
                  },
                  script: '_score + doc["alignments.id"].values.intersect(ids).size()'
                }
              }
            end

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

                    if params[:grade].present?
                      must do
                        nested do
                          path 'grades'
                          filter do
                            term 'grades.id' => params[:grade]
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
                      should { match 'title' => { query: params[:query], boost: 4 } }
                      should { match 'grade.grade.raw' => { query: params[:query], boost: 4} }
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
