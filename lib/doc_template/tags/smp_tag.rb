module DocTemplate
  module Tags
    class SmpTag < BlockTag
      TAG_NAME = 'smp'.freeze
      TEMPLATE = 'smp.html.erb'.freeze

      def parse(node, opts = {})
        nodes = block_nodes node
        nodes.each(&:remove)

        params = {
          content: parse_nested(nodes.map(&:to_html).join, opts),
          smp: opts[:value].split(';').map(&:strip)
        }
        @result = node.replace parse_template(params, TEMPLATE)
        self
      end
    end
  end

  Template.register_tag(Tags::SmpTag::TAG_NAME, Tags::SmpTag)
end
