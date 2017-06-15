module DocTemplate
  module Tags
    class InsetTag < BaseTag
      END_VALUE = 'end'.freeze
      STYLES_REGEXP = {
        bold: /font-weight:[6-9]00/i,
        italic: /font-style:italic/i
      }.freeze
      TAG_NAME = 'inset'.freeze

      def parse(node, opts = {})
        if opts[:value] == END_VALUE
          node.remove
        else
          nodes = block_nodes(node)
          content = parse_nested nodes.map(&:to_html).join, opts
          nodes.each(&:remove)
          node = node.replace "<div class='o-ld-inset'>#{content}</div>"
        end

        @result = node
        self
      end

      private

      def block_nodes(node)
        # we have to collect all nodes until the we find the end tag
        end_regexp = /\[#{TAG_NAME}:\s*#{END_VALUE}\]/
        [].tap do |result|
          while (node = node.next_sibling)
            break if node.content.downcase =~ end_regexp
            node = preserve_styles(node)
            result << node
          end
        end
      end

      def preserve_styles(node)
        node.children.each do |el|
          el['class'] = el['class'].to_s + ' text-bold' if el['style'] =~ STYLES_REGEXP[:bold]
          el['class'] = el['class'].to_s + ' text-italic' if el['style'] =~ STYLES_REGEXP[:italic]
        end
        node
      end
    end
  end

  Template.register_tag(Tags::InsetTag::TAG_NAME, Tags::InsetTag)
end
