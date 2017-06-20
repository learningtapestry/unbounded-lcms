module DocTemplate
  module Tags
    class IndentTag < BaseTag
      TAG_NAME = 'indent'.freeze
      TEMPLATE = 'indent.html.erb'.freeze

      def parse(node, opts = {})
        params = {
          content: parse_nested(remove_tag_from(node), opts)
        }
        @result = node.replace parse_template(params, TEMPLATE)
        self
      end
    end
  end

  Template.register_tag(Tags::IndentTag::TAG_NAME, Tags::IndentTag)
end
