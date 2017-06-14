module DocTemplate
  module Tags
    class MaterialsTag < BaseTag
      # BREAK_TAG_NAME = 'break'.freeze
      TAG_NAME = 'materials'.freeze
      TEMPLATE = 'materials.html.erb'.freeze

      def parse(node, opts = {})
        # we have to collect all the next siblings until next activity-metadata
        content = wrap_content(node)

        # TODO: maybe we need to expand parent tags approach to all nested tags
        node = node.replace(
          parse_template(
            parse_nested(content, opts.merge(parent_tags: [self.class::TAG_NAME])),
            TEMPLATE
          )
        )
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::MaterialsTag::TAG_NAME, Tags::MaterialsTag)
end
