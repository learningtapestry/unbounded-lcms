module DocTemplate
  module Tags
    class GlsTag < BaseTag
      TAG_NAME = 'gls'.freeze

      def parse(node, opts = {})
        @result = node
        @result.at_xpath(STARTTAG_XPATH).before("<em>#{opts[:value]}</em>")
        remove_node
        self
      end
    end
  end

  Template.register_tag(Tags::GlsTag::TAG_NAME, Tags::GlsTag)
end
