TEST_PATH = File.dirname(__FILE__)

if defined? Rails
  require "#{Rails.root}/test/test_helper"
end

require 'active_support/test_case'
require 'database_cleaner'
require 'json'
require 'minitest/autorun'
require 'webmock/minitest'; WebMock.allow_net_connect!
require 'content/models'
require 'content/test/elasticsearch_test_helpers'

module Content
  module Test
    # Base test class.
    class ContentTestBase < ActiveSupport::TestCase
      self.fixture_path = File.join(TEST_PATH, 'fixtures')

      Content::Models.constants
      .map { |c| Content::Models.const_get(c) }
      .select { |c| c <= ActiveRecord::Base }
      .each do |c|
        set_fixture_class c.name.demodulize.tableize => c
      end

      fixtures :all

      def setup
        super
        DatabaseCleaner[:active_record].strategy = :transaction
        DatabaseCleaner.start
      end

      def teardown
        super
        DatabaseCleaner.clean
      end
    end

    # Base Webmock test class.
    class WebmockTestBase < ContentTestBase
      def setup
        super
        WebMock.disable_net_connect!
      end

      def teardown
        super
        WebMock.allow_net_connect!
      end
    end

    # Base Elasticsearch test class.
    class ElasticsearchTestBase < ContentTestBase
      include ElasticsearchTestHelpers

      def setup
        super
        
        if check_elasticsearch
          prefix_index_names
          create_indeces
        else
          skip
        end
      end

      def teardown
        super
        
        if check_elasticsearch
          restore_original_index_names
        end
      end
    end

    module EnvelopeHelpers
      def read_envelope(name)
        JSON.parse(File.read(File.join(TEST_PATH, 'envelopes', "#{name}.json")))
      end
    end
  end
end
