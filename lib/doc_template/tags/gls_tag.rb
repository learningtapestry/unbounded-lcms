module DocTemplate
  module Tags
    class GlsTag < BaseTag
      TAG_NAME = 'gls'.freeze
      TEMPLATE = 'gls.html.erb'.freeze

      def parse(node, opts = {})
        parsed_content = parse_template({ content: opts[:value] }, TEMPLATE)
        node.inner_html = node.inner_html.sub FULL_TAG, parsed_content
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::GlsTag::TAG_NAME, Tags::GlsTag)
end
