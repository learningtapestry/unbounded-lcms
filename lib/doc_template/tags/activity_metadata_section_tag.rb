module DocTemplate
  module Tags
    class ActivityMetadataSectionTag < BaseTag
      TAG_NAME = 'activity-metadata-section'.freeze
      TEMPLATE = 'h2-header.html.erb'.freeze

      def parse(node, opts = {})
        section = opts[:activity].level1_by_title(opts[:value])
        node.replace(parse_template(section, TEMPLATE))
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataSectionTag::TAG_NAME, Tags::ActivityMetadataSectionTag)
end
