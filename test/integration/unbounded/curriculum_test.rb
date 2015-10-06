require 'test_helper'

module Unbounded
  class CurriculumTestCase < IntegrationTestCase
    def setup
      super
      use_poltergeist
    end

    # def test_subject_dropdown
    #   visit '/curriculum'
    #   wait_for_load
    #   assert has_select?('curriculum', options: ['English Language Arts', 'Mathematics'])
    # end

    def wait_for_load
      wait_until { evaluate_script("$('.module').length") }
    end
  end
end
