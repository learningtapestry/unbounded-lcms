module DocTemplate
  module Tags
    class Ela6BreakTag < BaseTag
      TAG_NAME = 'optbreak'.freeze
      TEMPLATE = 'ela-6-optbreak.html.erb'.freeze

      def parse(node, opts = {})
        table = node.ancestors('table')
        content_node = node.ancestors('tr').first
        node.remove
        return self unless table.present?
        @result = table.before(
          parse_nested(
            parse_template(fetch_content(content_node), TEMPLATE),
            opts
          )
        )
        # remove table if it's last tr
        content_node.next_element ? content_node.remove : table.remove
        # add break to agenda
        opts[:agenda].add_break
        self
      end

      private

      def fetch_content(node)
        node.at_xpath('./td[1]').try(:inner_html) || ''
      end
    end

    Template.register_tag(Tags::Ela6BreakTag::TAG_NAME, Ela6BreakTag)
  end
end
