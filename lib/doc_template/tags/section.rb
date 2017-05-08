module DocTemplate
  class SectionTag < Tag
    TAG_NAME = 'section'.freeze
    TEMPLATE = 'ela-6-section.html.erb'.freeze

    def parse(node, opts = {})
      section = opts[:agenda].section_by_id(opts[:value].parameterize)
      return parse_ela6(node, section) if ela6?(opts[:metadata])
      node.replace(
        <<-HEADER
          <h3 id="#{section.id}" class='o-ld-title c-ld-toc u-margin-top--large' data-node-time="#{section.metadata.time}">
            <span class='o-ld-title__title o-ld-title__title--h3'>#{section.title}</span>
            <span class='o-ld-title__time o-ld-title__time--h3'>#{section.metadata.time} mins</span>
          </h3>
        HEADER
      )
      @result = node
      self
    end

    private

    def parse_ela6(node, section)
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
                           blockquote: strip_quote(blockquote) },
                         TEMPLATE)
        )
      )
      # remove table only if there are no more rows
      table.remove unless content_node.next_sibling
      self
    end

    def fetch_content(node)
      sibling = node
      ['', ''].tap do |result|
        while sibling
          break if sibling.inner_html =~ /\[\s*(#{SectionTag::TAG_NAME}|#{GroupTag::TAG_NAME})/i
          sibling.xpath('./td').each_with_index do |child, idx|
            result[idx % 2] += child.inner_html
          end
          sibling.remove unless node == sibling
          sibling = node.next_sibling
        end
      end
    end

    def strip_quote(blockquote)
      return '' if Sanitize.fragment(blockquote, elements: []).strip.empty?
      blockquote
    end
  end

  Template.register_tag(SectionTag::TAG_NAME, SectionTag)
end
