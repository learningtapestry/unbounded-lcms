# frozen_string_literal: true

module DocTemplate
  class Document
    # Contains the list of tags for which no parts should be created
    TAGS_WITHOUT_PARTS = [
      Tags::DefaultTag::TAG_NAME,
      Tags::GlsTag::TAG_NAME,
      Tags::MaterialsTag::TAG_NAME,
      '#'
    ].freeze

    attr_accessor :parts

    def self.parse(nodes, opts = {})
      new.parse(nodes, opts)
    end

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

    def render
      @nodes.to_html
    end

    private

    def add_custom_nodes
      return unless @opts[:metadata].try(:subject).to_s.casecmp('ela').zero?
      return unless ela_teacher_guidance_allowed?

      @nodes.prepend_child ela_teacher_guidance(@opts[:metadata])
    end

    def ela_teacher_guidance(metadata)
      @data = metadata
      template = "ela-#{@opts[:metadata]['grade']}-teacher-guidance.html.erb"
      template_name = Rails.root.join 'lib', 'doc_template', 'templates', template
      template = File.read template_name
      ERB.new(template).result(binding)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def ela_teacher_guidance_allowed?
      # only for G6 and G2 (except U1)
      # As stated on issue #240 and here https://github.com/learningtapestry/unbounded/pull/267#issuecomment-307870881
      g2 = @opts[:metadata]['grade'] == '2'
      g6 = @opts[:metadata]['grade'] == '6'
      return false unless g2 || g6
      return false if g2 && @opts[:metadata]['unit'] == '1'

      # Additional filter for lessons
      # https://github.com/learningtapestry/unbounded/issues/311
      g2_u2 = g2 && @opts[:metadata]['unit'] == '2'
      return false if g2_u2 && %w(8 16 17 18).include?(@opts[:metadata]['lesson'])

      true
    end

    def find_tag(name, value = '')
      key = registered_tags.keys.detect do |k|
        if k.is_a?(Regexp)
          name =~ k
        else
          k == name or k == [name, value].join(' ')
        end
      end
      registered_tags[key]
    end

    #
    # catch invalid tags and report about them
    #
    def handle_invalid_tag(node)
      return if FULL_TAG.match(node.text).present?
      raise DocumentError, "No closing bracket for node:<br>#{node.to_html}"
    end

    def parse_node(node)
      matches = FULL_TAG.match(node.text)
      return if matches.nil?

      tag_name, tag_value = matches.captures
      return unless (tag = find_tag tag_name.downcase, tag_value.downcase)

      parsed_tag = tag.parse(node, @opts.merge(parent_document: self, value: tag_value))

      parsed_content = parsed_tag.content.presence || parsed_tag.render.to_s
      sanitized_content = HtmlSanitizer.post_processing(parsed_content, @opts[:metadata].try(:subject))

      return if TAGS_WITHOUT_PARTS.include?(tag::TAG_NAME)

      @parts << {
        content: sanitized_content.squish,
        materials: parsed_tag.materials,
        placeholder: parsed_tag.placeholder,
        part_type: tag_name.underscore
      }
    end

    def registered_tags
      Template.tags
    end
  end
end
