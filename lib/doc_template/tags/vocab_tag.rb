module DocTemplate
  module Tags
    class VocabTag < BlockTag
      TAG_NAME = 'vocab'.freeze
      TEMPLATE = 'vocab.html.erb'.freeze

      def parse(node, opts = {})
        nodes = block_nodes node
        nodes.each(&:remove)

        params = {
          content: parse_nested(nodes.map(&:to_html).join, opts)
        }
        @content = parse_template params, TEMPLATE
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::VocabTag::TAG_NAME, Tags::VocabTag)
end
