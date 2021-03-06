# frozen_string_literal: true

module DocTemplate
  module Tags
    class BaseTag
      CONFIG_PATH = Rails.root.join('config', 'tags.yml')
      MAX_ITERATIONS = 100
      SOFT_RETURN_RE = /([[:graph:]]+\[|\][[:graph:]]+)/
      UNICODE_SPACES_RE = /(\u0020|\u00A0|\u1680|\u180E|[\u2000-\u200B]|\u202F|\u205F|\u3000|\uFEFF)/

      attr_reader :content, :anchor

      def self.config
        @config ||= YAML.load_file(CONFIG_PATH)
      end

      def self.parse(node, opts = {})
        new.parse(node, opts)
      end

      def self.template_path_for(name)
        Rails.root.join 'lib', 'doc_template', 'templates', name
      end

      #
      # Preceeds the specified element with tag's placeholder
      #
      def before_tag(node)
        node.before Nokogiri::HTML.fragment(placeholder)
      end

      def check_tag_soft_return(node)
        # need to remove unicode spaces bc they're not handled by [[:graph:]]
        return unless node.content.gsub(UNICODE_SPACES_RE, '') =~ SOFT_RETURN_RE
        raise DocumentError,
              "Soft return for #{self.class::TAG_NAME} detected: #{node.content}, use hard return instead"
      end

      def content_until_break(node)
        [].tap do |result|
          check_tag_soft_return(node)
          while (sibling = node.next_sibling)
            break if include_break?(sibling)
            result << sibling.to_html
            sibling.remove
          end
        end.join
      end

      def content_until_materials(node)
        [].tap do |result|
          check_tag_soft_return(node)
          while (sibling = node.next_sibling)
            break if include_break_for?(sibling, 'stop_materials_tags')
            result << sibling.to_html
            sibling.remove
          end
        end.join
      end

      def ela2?(metadata)
        metadata.resource_subject == 'ela' && metadata.grade == '2'
      end

      def ela6?(metadata)
        metadata.resource_subject == 'ela' && metadata.grade == '6'
      end

      def gdoc?(opts)
        opts[:context_type].to_s.casecmp('gdoc').zero?
      end

      def include_break?(node)
        include_break_for? node, 'stop_tags'
      end

      def include_break_for?(node, key)
        tags =
          self.class.config[self.class::TAG_NAME.downcase][key].map do |stop_tag|
            Tags.const_get(stop_tag)::TAG_NAME
          end.join('|')
        result = node.content =~ /\[\s*(#{tags})/i
        check_tag_soft_return(node) if result
        result
      end

      def materials
        @materials || []
      end

      def parse(node, _ = {})
        @result = node
        remove_tag
        self
      end

      def parse_nested(node, opts = {})
        if node == opts[:parent_node]
          opts[:iteration] = opts[:iteration].to_i + 1
          raise DocumentError, "Loop detected for node:<br>#{node}" if opts[:iteration] > MAX_ITERATIONS
        end
        parsed = Document.parse(Nokogiri::HTML.fragment(node), opts.merge(level: 1))
        # add the parts to the parent document
        opts[:parent_document].parts += parsed.parts if opts[:parent_document]
        parsed.render
      end

      def parse_template(context, template_name)
        @tmpl = context
        template = File.read template_path(template_name)
        ERB.new(template).result(binding)
      end

      def placeholder
        @_placeholder ||= "{{#{placeholder_id}}}"
      end

      def placeholder_id
        @placeholder_id ||= "#{self.class.name.demodulize.underscore}_#{SecureRandom.hex(10)}"
      end

      def remove_tag
        start_tag_index = @result.children.index(@result.at_xpath(STARTTAG_XPATH))
        end_tag_index = @result.children.index(@result.at_xpath(ENDTAG_XPATH))
        @result.children[start_tag_index..end_tag_index].each do |node|
          if node.content =~ /.+\[[^\]]+\]|\[[^\]]+\].+/
            # a tag followed or preceeded by anything else
            # removes the tag itself - everything between `[` and `]`
            node.content = node.content.sub(/\[[^\[\]]+\]/, '')
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

      def render
        @result.to_s.presence || placeholder
      end

      #
      # Replaces the tag element with its placeholder
      #
      def replace_tag(node)
        node.replace Nokogiri::HTML.fragment(placeholder)
      end

      def tag_data
        {}
      end

      def template_name(opts)
        self.class::TEMPLATES[opts.fetch(:context_type, :default).to_sym]
      end

      def template_path(name)
        self.class.template_path_for name
      end
    end
  end
end
