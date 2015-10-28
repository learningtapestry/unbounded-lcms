module Content
  module Test
    module ElasticsearchTestable
      def setup
        super

        begin
          Elasticsearch::Model.client.perform_request('GET', '_cluster/health')
          Models::Searchable.searchables.each { |s| s.__elasticsearch__.create_index! }
        rescue Faraday::ConnectionFailed; end
      end
    end
  end
end
