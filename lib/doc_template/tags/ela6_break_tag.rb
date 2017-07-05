module DocTemplate
  module Tags
    class Ela6BreakTag < BaseTag
      TAG_NAME = 'optbreak'.freeze
      TEMPLATE = 'ela-6-optbreak.html.erb'.freeze

      def parse(node, opts = {})
        table = node.ancestors('table')
        unless table.present?
          node.remove
          return self
        end

        content_row = node.ancestors('tr').first
        node.remove

        # parses template and stores it to be used as a chunk
        parsed_template = parse_template fetch_content(content_row), TEMPLATE
        @content = parse_nested parsed_template, opts

        before_tag table

        # remove table if it's last tr
        content_row.next_element ? content_row.remove : table.remove

        # add break to agenda
        opts[:agenda].add_break
        self
      end

      private

      def fetch_content(node)
        return '' if node.nil?
        node.at_xpath('./td[1]').try(:inner_html) || ''
      end
    end

    Template.register_tag(Tags::Ela6BreakTag::TAG_NAME, Ela6BreakTag)
  end
end
