module DocTemplate
  module Tags
    class OptBreakTag < BaseTag
      TAG_NAME = 'optbreak'.freeze
      TEMPLATE = 'opt_break.html.erb'.freeze

      def parse(node, opts = {})
        content = content_until_break node
        parsed_template = parse_template content, TEMPLATE
        @content = parse_nested parsed_template, opts

        replace_tag node

        # add break to agenda
        opts[:agenda].add_break
        self
      end
    end

    Template.register_tag(Tags::OptBreakTag::TAG_NAME, OptBreakTag)
  end
end
