require 'content/test/elasticsearch_test_helpers'

module IntegrationDatabase
  def self.included(base)
    class << base; attr_reader :integration_database; end
    base.extend(ClassMethods)
    base.include(Content::Test::ElasticsearchTestHelpers)
  end

  module ClassMethods
    def uses_integration_database
      @integration_database = true
    end
  end

  def setup
    if self.class.integration_database
      ActiveRecord::Base.establish_connection(:integration)

      if check_elasticsearch
        prefix_index_names('integration')
        create_indeces
      end
    end
    super
  end

  def teardown
    if self.class.integration_database
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)

      if check_elasticsearch
        prefix_index_names
      end
    end
    super
  end
end
