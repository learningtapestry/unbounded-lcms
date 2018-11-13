# frozen_string_literal: true

module DocTemplate
  module Tables
    Metadata.class_eval do
      HTML_VALUE_FIELDS = %w(description materials preparation lesson-objective
                             relationship-to-eny1).freeze
    end
  end
end