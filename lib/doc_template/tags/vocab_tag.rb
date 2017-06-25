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
        @result = node.replace parse_template(params, TEMPLATE)
        self
      end
    end
  end

  Template.register_tag(Tags::VocabTag::TAG_NAME, Tags::VocabTag)
end
