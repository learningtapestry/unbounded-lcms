module IntegrationDatabase
  def self.included(base)
    unless base.ancestors.include?(Content::Test::ElasticsearchTestable)
      base.include(Content::Test::ElasticsearchTestable)
    end

    base.instance_eval do
      @integration_database = false
    end

    base.extend(ClassMethods)
  end

  module ClassMethods
    def uses_integration_database
      @integration_database = true
      self.elasticsearch_prefix = 'integration'
    end

    def integration_database
      @integration_database
    end
  end

  def uses_integration_database?
    self.class.integration_database
  end

  def setup
    if uses_integration_database?
      ActiveRecord::Base.establish_connection(:integration)
    end
    super
  end

  def teardown
    super
    if uses_integration_database?
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
      self.elasticsearch_prefix = 'test'
    end
  end
end
