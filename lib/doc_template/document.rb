module DocTemplate
  class Document
    def self.parse(nodes, opts = {})
      new.parse(nodes, opts)
    end

    def parse(nodes, opts = {})
      @nodes = nodes
      @opts = opts

      # find all tags
      #
      @nodes.xpath(ROOT_XPATH + STARTTAG_XPATH).each do |node|
        # identify the tag, take the siblings or enclosing and send it to the
        # relative tag class to render it

        next unless (tag_node = node.parent)
        # skip invalid tags (not closing)
        next if FULL_TAG.match(tag_node.text).nil?

        # how many open tags are in the current node?
        node.text.count('[').times do
          matches = FULL_TAG.match(tag_node.text)
          break if matches.nil?

          tag_name, tag_value = matches.captures
          next unless (tag = registered_tags[tag_name.downcase])

          tag.parse(tag_node, @opts.merge(value: tag_value)).render
        end
      end

      add_custom_nodes unless opts.key?(:level)

      self
    end

    def render
      @nodes.to_html
    end

    private

    def add_custom_nodes
      # Custom header for ELA G6
      if @opts[:metadata]['subject'].try(:downcase) == 'ela' and @opts[:metadata]['grade'] == '6'
        # Prepend the lesson with predefined element
        @nodes.prepend_child ela_6_teacher_guidance(@opts[:metadata])
      end
    end

    def ela_6_teacher_guidance(metadata)
      @data = metadata
      template_name = File.join Rails.root, 'lib', 'doc_template', 'templates', 'ela-6-teacher-guidance.html.erb'
      template = File.read template_name
      ERB.new(template).result(binding)
    end

    def registered_tags
      Template.tags
    end
  end
end
