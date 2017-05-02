module DocTemplate
  class Document
    def self.parse(nodes)
      doc = new
      doc.parse(nodes)
    end

    def parse(nodes)
      @nodes = nodes

      # identify the tag, take the siblings or enclosing and send it to the
      # relative tag class to render it

      # find all tags
      #
      @nodes.xpath(ROOT_XPATH + STARTTAG_XPATH).each do |node|
        tag_node = node.parent
        # skip invalid tags (not closing)
        next if FULL_TAG.match(tag_node.text).nil?
        tag_name, tag_value = FULL_TAG.match(tag_node.text).captures
        next unless (tag = registered_tags[tag_name.downcase])

        tag.parse(tag_node, value: tag_value).render
      end

      self
    end

    def render
      @nodes.to_html
    end

    private

    def registered_tags
      Template.tags
    end
  end
end
