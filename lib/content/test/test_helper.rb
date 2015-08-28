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
      def self.check_elasticsearch
        begin
          Elasticsearch::Model.client.perform_request('GET', '_cluster/health')
          true
        rescue StandardError
          false
        end
      end

      def setup
        super
        
        if ElasticsearchTestBase.check_elasticsearch
          refresh_indeces
        else
          skip
        end
      end

      def bulk_import_fixtures
        bulk_data = []
        Dir[File.join(TEST_PATH, 'fixtures', 'elasticsearch', '*.json')].each do |f|
          File.readlines(f).each do |line|
            bulk_data << JSON.load(line)
          end
        end

        Elasticsearch::Model.client.bulk(body: bulk_data)
        
        Models::Searchable.searchables.each do |searchable|
          searchable.__elasticsearch__.refresh_index!
        end
      end

      def refresh_indeces
        Models::Searchable.searchables.each do |searchable|
          unless searchable.index_name.start_with?('test_')
            searchable.index_name("test_#{searchable.index_name}")
          end
          searchable.__elasticsearch__.create_index!(force: true)
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
