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
      establish_connection(:integration)
      Content::Models::Lobject.index_name 'integration_content-models-lobjects'
    end
    super
  end

  def teardown
    super
    if uses_integration_database?
      establish_connection(Rails.env.to_s)
      Content::Models::Lobject.index_name 'test_content-models-lobjects'
    end
  end

  private
    def establish_connection(env)
      Dotenv.overload(".env.#{env}")
      config = Rails.application.config.database_configuration[env.to_s]
      ActiveRecord::Base.establish_connection(config)
    end
end
