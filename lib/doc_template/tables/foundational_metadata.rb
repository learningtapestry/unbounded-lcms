# frozen_string_literal: true

module DocTemplate
  module Tables
    class FoundationalMetadata < Base
      HEADER_LABEL = 'foundational-metadata'
      HTML_VALUE_FIELDS = %w(lesson-objective).freeze

      def parse(fragment)
        path = ".//table/*/tr[1]/td//*[case_insensitive_equals(text(),'#{HEADER_LABEL}')]"
        fragment.xpath(path, XpathFunctions.new).each do |el|
          table = el.ancestors('table').first
          # consider a foundational skill as a section group
          value = 'foundational-skills'
          header = "<p><span>[#{::DocTemplate::Tags::ActivityMetadataSectionTag::TAG_NAME}: #{value}]</span></p>"
          table.add_next_sibling header
        end
        super
      end
    end
  end
end
