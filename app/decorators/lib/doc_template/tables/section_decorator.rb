# frozen_string_literal: true

module DocTemplate
  module Tables
    Section.class_eval do
      def parse(fragment, _template_type)
        path = ".//table/*/tr[1]/td//*[case_insensitive_equals(text(),'#{HEADER_LABEL}')]"
        [].tap do |result|
          fragment.xpath(path, XpathFunctions.new).each do |el|
            table = el.ancestors('table').first
            data = fetch table

            value = data['section-title'].parameterize
            header = "<p><span>[#{::DocTemplate::Tags::ActivityMetadataSectionTag::TAG_NAME}: #{value}]</span></p>"
            table.replace header

            data = fetch_materials data, MATERIALS_KEY

            result << data
          end
        end
      end
    end
  end
end