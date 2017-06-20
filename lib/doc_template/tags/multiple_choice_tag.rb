module DocTemplate
  module Tags
    class MultipleChoiceTag < BlockTag
      TAG_NAME = 'multiple-choice'.freeze

      def parse(node, opts = {})
        nodes = block_nodes node
        content = parse_nested nodes.map(&:to_html).join, opts
        nodes.each(&:remove)
        @result = node.replace "<div class='o-ld-multiple-choice'>#{content}</div>"
        self
      end
    end
  end

  Template.register_tag(Tags::MultipleChoiceTag::TAG_NAME, Tags::MultipleChoiceTag)
end
