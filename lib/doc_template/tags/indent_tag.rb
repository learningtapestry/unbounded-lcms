module DocTemplate
  module Tags
    class IndentTag < BaseTag
      TAG_NAME = 'indent'.freeze
      TEMPLATE = 'indent.html.erb'.freeze

      def parse(node, opts = {})
        content_without_tag = node.to_html.sub FULL_TAG, ''
        params = {
          content: parse_nested(content_without_tag, opts)
        }
        @content = parse_template(params, TEMPLATE)
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::IndentTag::TAG_NAME, Tags::IndentTag)
end
