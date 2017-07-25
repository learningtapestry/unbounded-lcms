# frozen_string_literal: true

module DocTemplate
  module Tags
    class GroupTag < BaseTag
      TAG_NAME = 'group'
      TEMPLATE = 'h2-header.html.erb'

      def parse(node, opts = {})
        group = opts[:agenda].level1_by_title(opts[:value].parameterize)
        node.replace(parse_template(group, TEMPLATE))
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::GroupTag::TAG_NAME, Tags::GroupTag)
end
