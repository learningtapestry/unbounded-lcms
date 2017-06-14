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
      while (node = @nodes.at_xpath ROOT_XPATH + STARTTAG_XPATH)
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
          next unless (tag = find_tag tag_name.downcase)

          tag.parse(tag_node, @opts.merge(value: tag_value)).render
        end
      end

      add_custom_nodes unless @opts.key?(:level)

      self
    end

    def render
      @nodes.to_html
    end

    private

    def add_custom_nodes
      return unless @opts[:metadata].present?
      return unless @opts[:metadata]['subject'].try(:downcase) == 'ela'

      # only for G6 or G2 U2 .
      # As stated on issue #240 and here https://github.com/learningtapestry/unbounded/pull/267#issuecomment-307870881
      return unless @opts[:metadata]['grade'] == '6' ||
                    (@opts[:metadata]['grade'] == '2' && @opts[:metadata]['unit'] == '2')

      @nodes.prepend_child ela_teacher_guidance(@opts[:metadata])
    end

    def ela_teacher_guidance(metadata)
      @data = metadata
      template = "ela-#{@opts[:metadata]['grade']}-teacher-guidance.html.erb"
      template_name = Rails.root.join 'lib', 'doc_template', 'templates', template
      template = File.read template_name
      ERB.new(template).result(binding)
    end

    def find_tag(name)
      key = registered_tags.keys.detect { |k| k.is_a?(Regexp) ? name =~ k : k == name }
      registered_tags[key]
    end

    def registered_tags
      Template.tags
    end
  end
end
