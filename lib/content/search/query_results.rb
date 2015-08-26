require 'elasticsearch/dsl'

module Content
  module Search
    class QueryResults
      attr_accessor :query, :results, :total_hits

      include Enumerable

      def initialize(query:, results:, total_hits:)
        @query = query
        @results = results
        @total_hits = total_hits
      end

      def each(&blk)
        results.each(&blk)
      end

      def size
        results.size
      end
    end
  end
end
