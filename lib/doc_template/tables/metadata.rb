# frozen_string_literal: true

module DocTemplate
  module Tables
    class Metadata < Base
      HEADER_LABEL = 'document-metadata'
      HTML_VALUE_FIELDS = %w(description materials preparation lesson-objective relationship-to-eny1).freeze

      def parse(fragment)
        super
        @data['subject'] = @data['subject'].to_s.downcase if @data.present?
        self
      end
    end
  end
end
