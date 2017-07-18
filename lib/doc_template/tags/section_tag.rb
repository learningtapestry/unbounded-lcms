module DocTemplate
  module Tags
    class SectionTag < BaseTag
      STUDENT_RE = /^\s*student\s*resources\s*$/i
      TAG_NAME = 'section'.freeze
      TEMPLATE_ELA = 'ela-2-6-section.html.erb'.freeze
      TEMPLATE = 'section.html.erb'.freeze
      TEMPLATE_SM = 'ela-headings.html.erb'.freeze

      def parse(node, opts = {})
        @opts = opts
        section = @opts[:agenda].level2_by_title(@opts[:value].parameterize)
        # TODO: need to be refactored, maybe wrap all structure tags with content
        # into divs (or sections) with css classes, will be easy to iterate and
        # split document into chunks
        # Anyway line below is for build ela2 tm/sm for now
        return parse_ela2_sm(node, section) if ela2?(@opts[:metadata]) && student_material?(section)
        return parse_ela(node, section) if ela2?(@opts[:metadata]) && section.use_color

        return parse_ela6_table(node, section) if ela6_with_tables?(@opts[:metadata])
        return parse_ela(node, section) if ela6?(@opts[:metadata])

        @result = node.replace(parse_template(section, TEMPLATE))
        self
      end

      private

      def parse_ela(node, section)
        params = {
          content: fetch_nodes_content(node),
          section: section
        }
        parsed_template = parse_template(params, TEMPLATE_ELA)
        @result = node.replace parse_nested(parsed_template, @opts)
        self
      end

      def parse_ela2_sm(node, section)
        content = content_until_break(node)

        node = node.replace(
          parse_template({ content: parse_nested(content, @opts),
                           heading: parse_template(section, TEMPLATE),
                           tag: 'ela2-sm' },
                         TEMPLATE_SM)
        )
        @result = node
        self
      end

      def parse_ela6_table(node, section)
        table = node.ancestors('table').first
        return self unless table.present?
        # section is in same cell as content
        content_node = node.ancestors('tr').first
        # section is in different tr as content
        content_node = content_node.next_element if node.parent.children.size == 1
        node.remove

        content, blockquote = fetch_table_content(content_node)
        params = {
          blockquote: strip_html_element(blockquote),
          content: content,
          section: section
        }
        parsed_template = parse_template(params, TEMPLATE_ELA)
        @result = table.before(parse_nested(parsed_template, @opts))

        # remove table only if there are no more rows
        table.remove unless content_node.next_element
        self
      end

      def fetch_nodes_content(node)
        nodes = [].tap do |result|
          while (node = node.next_sibling)
            break if include_break?(node)
            result << node
          end
        end

        nodes.each(&:remove).map(&:to_html).join
      end

      def fetch_table_content(node)
        sibling = node
        ['', ''].tap do |result|
          while sibling
            break if include_break?(sibling)
            sibling.xpath('./td').each_with_index do |child, idx|
              result[idx % 2] += child.inner_html
            end
            sibling.remove unless node == sibling
            sibling = node.next_sibling
          end
        end
      end

      def student_material?(section)
        section.title =~ STUDENT_RE
      end
    end
  end

  Template.register_tag(Tags::SectionTag::TAG_NAME, Tags::SectionTag)
end
