# frozen_string_literal: true

module DocTemplate
  module Tags
    class GroupTag < BaseTag
      TAG_NAME = 'group'
      TEMPLATES = {
        default: 'group-ela.html.erb',
        gdoc: 'gdoc/group-ela.html.erb'
      }.freeze

      def parse(node, opts = {})
        group = opts[:agenda].level1_by_title(opts[:value].parameterize)
        @anchor = group.anchor
        content = content_until_break node
        content = parse_nested content.to_s, opts
        params = {
          content: content,
          placeholder: placeholder_id,
          group: group
        }
        @content = parse_template params, template_name(opts)
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::GroupTag::TAG_NAME, Tags::GroupTag)
end
