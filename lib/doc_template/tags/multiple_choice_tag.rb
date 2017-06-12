module DocTemplate
  module Tags
    class MultipleChoiceTag < BaseTag
      TAG_NAME = 'multiple-choice'.freeze
      END_VALUE = 'end'.freeze

      def parse(node, opts = {})
        if opts[:value] == END_VALUE
          node.remove
        else
          nodes = block_nodes(node)
          content = parse_nested nodes.map(&:to_html).join
          nodes.each(&:remove)
          node = node.replace "<div class='o-ld-multiple-choice'>#{content}</div>"
        end

        @result = node
        self
      end

      private

      def block_nodes(node)
        # we have to collect all nodes until the we find the end tag
        [].tap do |result|
          while (node = node.next_sibling)
            break if end?(node)
            result << node
          end
        end
      end

      def end?(node)
        node.content.downcase =~ /\[#{TAG_NAME}:\s*#{END_VALUE}\]/
      end
    end
  end

  Template.register_tag(Tags::MultipleChoiceTag::TAG_NAME, Tags::MultipleChoiceTag)
end
