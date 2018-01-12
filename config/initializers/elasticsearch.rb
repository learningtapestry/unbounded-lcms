# frozen_string_literal: true

require 'elasticsearch/model'
require "#{Rails.root}/lib/elasticsearch/persistence/repository/response/results"

Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV['ELASTICSEARCH_ADDRESS']
)
Hashie.logger = Logger.new('/dev/null')
