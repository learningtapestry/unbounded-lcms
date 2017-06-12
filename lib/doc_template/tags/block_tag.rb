module DocTemplate
  module Tags
    class BlockTag < BaseTag
      def add_tags_from(node, tags = [])
        re = DocTemplate::Tags::StandardTag::TAG_RE
        return unless (m = re.match node.inner_html)

        m.to_a.each do |tag|
          tags << tag
          node.content = node.content.sub re, "{tag: #{tags.size - 1}}"
        end

        tags
      end

      def substitute_tags_in(content, tags = [])
        re = /{tag: (\d)+}/
        content.scan(re).each do |idx|
          next unless (tag = tags[idx.first.to_i]).present?
          parsed_tag = parse_nested "<p><span>#{tag}</span></p>"
          content = content.sub re, parsed_tag
        end
        content
      end
    end
  end
end
