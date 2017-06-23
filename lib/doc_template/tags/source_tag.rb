module DocTemplate
  module Tags
    class SourceTag < BaseTag
      TAG_NAME = 'source'.freeze

      def parse(node, opts = {})
        content = [].tap do |result|
          while (sibling = node.next_sibling) do
            break if include_break?(sibling.content)
            result << sibling.to_html
            sibling.remove
          end
        end.join

        node.replace placeholder_tag
        @result = parse_nested(content, opts)
        self
      end
    end
  end

  Template.register_tag(Tags::SourceTag::TAG_NAME, Tags::SourceTag)
end
