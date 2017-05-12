module DocTemplate
  module Tags
    class CalloutTag < BaseTag
      TAG_NAME = 'callout'.freeze
      TEMPLATE = 'callout.html.erb'.freeze

      def parse(node, opts = {})
        table = node.ancestors('table').first
        return self unless table.present?
        header, content = fetch_content(table)

        @result = (table.previous_element || table).before(
          parse_nested(
            parse_template({ header: header,
                             content: content,
                             subject: opts[:metadata].resource_subject },
                           TEMPLATE),
            opts
          )
        )
        table.remove
        self
      end

      def fetch_content(node)
        ['', ''].tap do |result|
          node.xpath('.//tr[position() > 1]/td').children.each_with_index do |child, idx|
            result[idx % 2] += child.inner_html
          end
        end
      end
    end

    Template.register_tag(Tags::CalloutTag::TAG_NAME, CalloutTag)
  end
end
