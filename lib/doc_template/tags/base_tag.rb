module DocTemplate
  module Tags
    class BaseTag
      CONFIG_PATH = Rails.root.join('config', 'tags.yml')

      def self.config
        @config ||= YAML.load_file(CONFIG_PATH)
      end

      def self.parse(node, opts = {})
        new.parse(node, opts)
      end

      def self.template_path_for(name)
        Rails.root.join 'lib', 'doc_template', 'templates', name
      end

      def content_until_break(node)
        [].tap do |result|
          while (sibling = node.next_sibling) do
            break if include_break?(sibling)
            result << sibling.to_html
            sibling.remove
          end
        end.join
      end

      def include_break?(node)
        tags =
          self.class.config[self.class::TAG_NAME.downcase]['stop_tags'].map do |stop_tag|
            Tags.const_get(stop_tag)::TAG_NAME
          end.join('|')
        node.content =~ /\[\s*(#{tags})/i
      end

      def ela2?(metadata)
        metadata.resource_subject == 'ela' && metadata.grade == '2'
      end

      def ela6?(metadata)
        metadata.resource_subject == 'ela' && metadata.grade == '6'
      end

      def parse(node, _ = {})
        # generate the new content
        @result = node
        remove_tag
        self
      end

      def parse_nested(node, opts = {})
        parsed = Document.parse(Nokogiri::HTML.fragment(node), opts.merge(level: 1))
        # add the parts to the root document
        if opts[:parent_document]
          opts[:parent_document].parts += parsed.parts
        end
        parsed.render
      end

      def parse_template(context, template_name)
        @tmpl = context
        template = File.read template_path(template_name)
        ERB.new(template).result(binding)
      end

      def remove_tag
        start_tag_index = @result.children.index(@result.at_xpath(STARTTAG_XPATH))
        end_tag_index = @result.children.index(@result.at_xpath(ENDTAG_XPATH))
        @result.children[start_tag_index..end_tag_index].each do |node|
          if node.content =~ /.+\[[^\]]+\]|\[[^\]]+\].+/
            # a tag followed or preceeded by anything else
            # removes the tag itself - everything between `[` and `]`
            node.content = node.content.sub /\[[^\[\]]+\]/, ''
          elsif (data = node.content.match(/^([^\[]*)\[|\]([^\[]*)$/))
            # if node contains open or closing tag bracket with general
            # text outside the bracket itself
            if (new_content = data[1].presence || data[2]).blank?
              node.remove
            else
              node.content = new_content
            end
          else
            node.remove
          end
        end
      end

      def remove_tag_from(node)
        node.inner_html.sub FULL_TAG, ''
      end

      def replace_tag_in(node, value)
        node.inner_html.sub FULL_TAG, value
      end

      def render
        @result || ''
      end

      def strip_html_element(element)
        return '' if Sanitize.fragment(element, elements: []).strip.empty?
        element
      end

      def template_path(name)
        self.class.template_path_for name
      end

      def placeholder
        @_placeholder ||= begin
                            random = SecureRandom.hex(10)
                            "#{self.class.name.demodulize.underscore}_#{random}"
                          end
      end

      def placeholder_tag
        "{{#{placeholder}}}"
      end
    end
  end
end
