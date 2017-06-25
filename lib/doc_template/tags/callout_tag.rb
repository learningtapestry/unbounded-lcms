module DocTemplate
  module Tags
    class CalloutTag < TableTag
      TAG_NAME = 'callout'.freeze
      TEMPLATE = 'callout.html.erb'.freeze

      def parse_table(table)
        header, content = fetch_content(table)
        params = {
          content: content,
          header: header,
          subject: @opts[:metadata].resource_subject
        }
        new_content = parse_template(params, TEMPLATE)
        parsed_content = parse_nested(new_content, @opts)
        @result = (previous_non_empty(table) || table).before(parsed_content)
        table.remove
      end

      private

      def fetch_content(node)
        [node.at_xpath('.//tr[2]/td').try(:content) || '',
         node.at_xpath('.//tr[3]/td').try(:inner_html) || '']
      end

      def previous_non_empty(node)
        while (node = node.previous_sibling)
          break unless node.content.squish.blank?
        end
        node
      end
    end

    Template.register_tag(Tags::CalloutTag::TAG_NAME, CalloutTag)
  end
end
