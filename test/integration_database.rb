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

  def uses_integration_database?
    self.class.integration_database
  end

  def setup
    if uses_integration_database?
      ActiveRecord::Base.establish_connection(:integration)

      if check_elasticsearch
        prefix_index_names('integration')
        create_indeces
      else
        skip
      end
    end
    super
  end

  def teardown
    super
    if uses_integration_database?
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)

      if check_elasticsearch
        restore_original_index_names
      end
    end
  end
end
