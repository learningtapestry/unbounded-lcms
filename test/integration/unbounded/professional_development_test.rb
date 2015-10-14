require 'test_helper'

module Unbounded
  class ProfessionalDevelopmentTestCase < IntegrationTestCase
    def test_show
      skip
      
      visit '/professional_development'
      assert has_content?('Professional Development')
    end
  end
end
