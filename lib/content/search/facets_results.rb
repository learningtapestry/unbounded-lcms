require 'elasticsearch/dsl'

module Content
  module Search
    class FacetsResults
      attr_reader :filters, :facets, :query

      include Enumerable
      
      def initialize(filters:, facets:, query: nil)
        @filters = filters
        @facets = facets
        @query = query
      end

      def each(&blk)
        facets.each(&blk)
      end
    end
  end
end
