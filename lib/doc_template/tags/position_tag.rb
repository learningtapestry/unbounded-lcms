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
        table.replace ERB.new(template).result(binding)
        @result = table
        self
      end
    end
  end

  Template.register_tag(Tags::PositionTag::TAG_NAME, Tags::PositionTag)
end
