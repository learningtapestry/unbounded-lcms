module DocTemplate
  module Tags
    class InsetTag < BaseTag
      TAG_NAME = 'inset'.freeze
      STYLES_REGEXP = {
        bold: /font-weight:[6-9]00/i,
        italic: /font-style:italic/i
      }.freeze

      def parse(node, opts = {})
        content = opts[:value] == 'end' ? '' : parse_content(node)
        node = node.replace content
        @result = node
        self
      end

      private

      def parse_content(node)
        # we have to collect all the next siblings until the we find the end tag
        [].tap do |result|
          while (sibling = node.next_sibling)
            break if end?(sibling)

            sibling = add_inset_class(sibling)
            sibling = preserve_styles(sibling)
            result << sibling.to_html
            sibling.remove
          end
        end.join
      end

      def end?(node)
        node.content =~ /\[#{TAG_NAME}:end\]/
      end

      def add_inset_class(node)
        node['class'] = node['class'].to_s + ' inset'
        node
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
