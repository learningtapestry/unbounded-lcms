# frozen_string_literal: true

module DocTemplate
  Document.class_eval do
    def parse(nodes, opts = {})
      @nodes = nodes
      @opts = opts
      @parts = @opts[:parts] || []

      # find all tags
      while (node = @nodes.at_xpath ROOT_XPATH + STARTTAG_XPATH)
        # identify the tag, take the siblings or enclosing and send it to the
        # relative tag class to render it
        next unless (tag_node = node.parent)

        handle_invalid_tag tag_node
        parse_node tag_node
      end

      add_custom_nodes unless @opts.key?(:level) || @opts.key?(:material)

      self
    end

    #
    # catch invalid tags and report about them
    #
    def handle_invalid_tag(node)
      return if FULL_TAG.match(node.text).present?

      raise DocumentError, "No closing bracket for node:<br>#{node.to_html}"
    end
  end

  def sanitized_content(parsed_content)
    HtmlSanitizer.post_processing(parsed_content, @opts)
  end
end