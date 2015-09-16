TEST_PATH = File.dirname(__FILE__)

require 'active_support/test_case'
require 'database_cleaner'
require 'json'
require 'minitest/autorun'
require 'webmock/minitest'; WebMock.allow_net_connect!
require 'content/models'
require 'content/test/elasticsearch_testable'
require 'content/test/content_fixtures'
require 'content/test/database_cleanable'

module Content
  module Test
    # Base test class.
    class ContentTestBase < ActiveSupport::TestCase
      include ContentFixtures
      include DatabaseCleanable
    end

    # Base Elasticsearch test class.
    class ElasticsearchTestBase < ContentTestBase
      include ElasticsearchTestable
    end

    module EnvelopeHelpers
      def read_envelope(name)
        JSON.parse(File.read(File.join(TEST_PATH, 'envelopes', "#{name}.json")))
      end
    end
  end
end
