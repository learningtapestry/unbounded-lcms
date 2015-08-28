module IntegrationDatabase
  def self.included(base)
    class << base; attr_reader :integration_database; end
    base.extend(ClassMethods)
  end

  module ClassMethods
    def uses_integration_database
      @integration_database = true
    end
  end

  def setup
    if self.class.integration_database
      ActiveRecord::Base.establish_connection(:integration)
    end
    super
  end

  def teardown
    if self.class.integration_database
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    end
    super
  end
end
