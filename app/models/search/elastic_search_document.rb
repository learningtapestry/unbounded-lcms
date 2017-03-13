module Search
  class ElasticSearchDocument
    # return the corresponding repository
    def self.repository
      @repository ||= ::Search::Repository.new
    end

    def repository
      self.class.repository
    end

    def index!
      repository.save self
    end

    def delete!
      repository.delete self
    end

    # Default search
    #
    # term: [String || Nil]
    #   - [Nil]    : return a match_all query
    #   - [String] : perform a `fts_query` on the repository
    #
    # options: [Hash]
    #   - per_page : number os results per page
    #   - page     : results page number
    #   - <filter> : any doc specific filters, e.g: 'grade', 'subject', etc
    #
    def self.search(term, options={})
      return repository.empty_response unless repository.index_exists?

      if term.present?
        query = repository.fts_query(term, options)
        repository.search query
      else
        query = repository.all_query(options)
        repository.search query
      end
    end

    # this is necessary for the ActiveModel::ArraySerializer#as_json method to work
    # (used on the concerns/pagination => #serialize_with_pagination)
    def read_attribute_for_serialization(key)
      if key == :id || key == 'id'
        attributes.fetch(key) { id }
      else
        attributes[key]
      end
    end
  end
end
