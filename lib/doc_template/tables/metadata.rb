module DocTemplate
  module Tables
    class Metadata < Base
      HEADER_LABEL = 'document-metadata'.freeze
      HTML_VALUE_FIELDS = %w(description materials preparation lesson-objective relationship-to-eny1).freeze
    end
  end
end

