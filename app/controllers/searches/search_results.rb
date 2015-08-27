module Searches
  class SearchResults
    attr_reader :results, :total_hits

    def initialize(results:, total_hits: results.size)
      @results = results
      @total_hits = total_hits
    end
  end
end
