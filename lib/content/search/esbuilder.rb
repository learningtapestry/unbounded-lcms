require 'elasticsearch/dsl'

module Content
  module Search
    class Esbuilder
      include Elasticsearch::DSL

      def self.build(&blk)
        new.search(&blk)
      end
    end
  end
end
