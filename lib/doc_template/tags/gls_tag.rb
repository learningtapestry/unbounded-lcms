module DocTemplate
  module Tags
    class GlsTag < BaseTag
      TAG_NAME = 'gls'.freeze
      TEMPLATE = 'gls.html.erb'.freeze

      def parse(node, opts = {})
        content = parse_template({ content: opts[:value] }, TEMPLATE)
        node.inner_html = replace_tag_in node, content
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::GlsTag::TAG_NAME, Tags::GlsTag)
end
