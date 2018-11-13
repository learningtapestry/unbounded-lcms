# frozen_string_literal: true

module DocTemplate
  module Tables
    Activity.class_eval do
      HTML_VALUE_FIELDS = %w(activity-metacognition activity-guidance alert).freeze
      MATERIALS_KEY = 'activity-materials'

      def process_title(data)
        data
      end
    end
  end
end