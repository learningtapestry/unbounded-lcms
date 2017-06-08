module DocTemplate
  module Tags
    class PositionTag < BaseTag
      include ERB::Util

      TAG_NAME = 'position'.freeze
      TEMPLATE = 'position.html.erb'.freeze

      def parse(node, opts = {})
        return self unless (table = node.ancestors('table').first)

        @content = table.at_xpath('.//tr[2]/td').inner_html
        @position = opts[:value].strip

        template = File.read template_path(TEMPLATE)
        new_content = ERB.new(template).result(binding)
        table.replace parse_nested new_content
        @result = table
        self
      end
    end
  end

  # TODO: Uncomment if we need to return position tag back in work
  # Template.register_tag(Tags::PositionTag::TAG_NAME, Tags::PositionTag)
end
