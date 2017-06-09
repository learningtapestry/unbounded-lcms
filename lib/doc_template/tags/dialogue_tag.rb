module DocTemplate
  module Tags
    class DialogueTag < BlockTag
      include ERB::Util

      END_VALUE = 'end'.freeze
      TAG_NAME = 'dialogue'.freeze
      TEMPLATE = 'dialogue.html.erb'.freeze

      def parse(node, opts = {})
        if opts[:value] == END_VALUE
          node.remove
        else
          @tags = []

          nodes = fetch_content node
          nodes.map(&:remove)

          @phrases = format_phrases nodes
          template = File.read template_path(TEMPLATE)
          node = node.replace ERB.new(template).result(binding)
        end

        @result = node
        self
      end

      private

      #
      # Going down the DOM tree until the end tag. Placing own markers
      # for nested tags and images to revert them back later on
      #
      def fetch_content(node)
        re = /\[#{TAG_NAME}:\s*#{END_VALUE}\]/
        [].tap do |result|
          while (node = node.next_sibling)
            node.remove && break if node.content.downcase.index(re).present?
            add_tags_from node, @tags
            result << node
          end
        end
      end

      def format_phrases(nodes)
        delimiter = '{|}'

        t_re = /T:/
        s_re = /S:/
        mixed_re = %r{T/S:}

        content = nodes.map(&:inner_html)
                    .join(delimiter)
                    .sub(t_re, '<strong>Teacher:</strong>')
                    .sub(s_re, '<strong>Student:</strong>')
                    .gsub(mixed_re, '<strong>T/S:</strong>')
                    .gsub(t_re, '<strong>T:</strong>')
                    .gsub(s_re, '<strong>S:</strong>')
                    .squish

        substitute_tags_in(content, @tags)
          .split(delimiter)
          .reject(&:blank?)
      end
    end
  end

  Template.register_tag(Tags::DialogueTag::TAG_NAME, Tags::DialogueTag)
end
