module DocTemplate
  module Tags
    class SectionTag < BaseTag
      TAG_NAME    = 'section'.freeze
      TEMPLATE    = 'ela-6-section.html.erb'.freeze
      TEMPLATE_H3 = 'h3-header.html.erb'.freeze

      def parse(node, opts = {})
        section = opts[:agenda].level2_by_title(opts[:value].parameterize)
        return parse_ela6(node, section, opts) if ela6?(opts[:metadata])
        node.replace(parse_template(section, TEMPLATE_H3))
        @result = node
        self
      end

      private

      def parse_ela6(node, section, opts)
        table = node.ancestors('table').first
        return self unless table.present?
        # section is in same cell as content
        content_node = node.ancestors('tr').first
        # section is in different tr as content
        content_node = content_node.next_element if node.parent.children.size == 1
        node.remove
        content, blockquote = fetch_content(content_node)
        @result = table.before(
          parse_nested(
            parse_template({ section: section,
                             content: content,
                             blockquote: strip_html_element(blockquote) },
                           TEMPLATE),
            opts
          )
        )
        # remove table only if there are no more rows
        table.remove unless content_node.next_element
        self
      end

      def fetch_content(node)
        sibling = node
        ['', ''].tap do |result|
          while sibling
            break if sibling.inner_html =~ /\[\s*(#{SectionTag::TAG_NAME}|#{GroupTag::TAG_NAME}|#{GroupTag::OPT_BREAK})/i
            sibling.xpath('./td').each_with_index do |child, idx|
              result[idx % 2] += child.inner_html
            end
            sibling.remove unless node == sibling
            sibling = node.next_sibling
          end
        end
      end
    end
  end

  Template.register_tag(Tags::SectionTag::TAG_NAME, Tags::SectionTag)
end
