require 'test_helper'

module Unbounded
  class LobjectShowTestCase < IntegrationTestCase
    def test_related_resource_type_video
      lobject = lobjects(:unbounded_lesson_1_1_1_1)
      visit "/resources/#{lobject.id}"
      assert all('.lesson-resources').first.has_content?('Video')
    end

    def test_related_resource_type_resource
      lobject = lobjects(:unbounded_unit_1_1_1)
      visit "/resources/#{lobject.id}"
      assert all('.lesson-resources').first.has_content?('Resource')
    end
  end
end
