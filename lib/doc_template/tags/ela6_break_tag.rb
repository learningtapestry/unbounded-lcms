module DocTemplate
  module Tags
    class Ela6BreakTag < BaseTag
      TAG_NAME = 'optbreak'.freeze
      TEMPLATE = 'ela-6-optbreak.html.erb'.freeze

      def parse(node, opts = {})
        table = node.ancestors('table')
        content_node = node.ancestors('td').first
        node.remove
        return self unless table.present?
        @result = table.before(
          parse_nested(
            parse_template(fetch_content(content_node), TEMPLATE),
            opts
          )
        )
        # remove table if it's last tr
        end_of_table = content_node.ancestors('tr').first.try(:next_element).nil?
        # we need it while next group tag processing
        content_node.replace("<td>#{Tags::GroupTag::OPT_BREAK}</td>")
        table.remove if end_of_table
        self
      end

      private

      def fetch_content(node)
        node.try(:inner_html) || ''
      end
    end

    Template.register_tag(Tags::Ela6BreakTag::TAG_NAME, Ela6BreakTag)
  end
end
