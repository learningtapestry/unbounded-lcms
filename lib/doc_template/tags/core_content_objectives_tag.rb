module DocTemplate
  module Tags
    class CoreContentObjectivesTag < BlockTag
      TAG_NAME = 'core content objectives'.freeze
      TEMPLATE = 'core_content_objectives.html.erb'.freeze

      def parse(node, opts = {})
        nodes = block_nodes node
        nodes.each(&:remove)

        params = {
          content: parse_nested(nodes.map(&:to_html).join, opts)
        }
        @content = parse_template(params, TEMPLATE)
        replace_tag node
        self
      end
    end

    Template.register_tag(Tags::CoreContentObjectivesTag::TAG_NAME, Tags::CoreContentObjectivesTag)
  end
end
