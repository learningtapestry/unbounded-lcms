module DocTemplate
  module Tags
    class DialogueTag < BaseTag
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

          params = { phrases: format_phrases(nodes) }
          node = node.replace parse_template(params, TEMPLATE)
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
            result << node
          end
        end
      end

      def format_phrases(nodes)
        delimiter = '{|}'

        t_re = /T:/
        s_re = /S:/
        mixed_re = %r{T/S:}

        nodes.map(&:to_html)
          .join(delimiter)
          .sub(t_re, '<strong>Teacher:</strong>')
          .sub(s_re, '<strong>Student:</strong>')
          .gsub(mixed_re, '<strong>T/S:</strong>')
          .gsub(t_re, '<strong>T:</strong>')
          .gsub(s_re, '<strong>S:</strong>')
          .squish
          .split(delimiter)
          .reject(&:blank?)
      end
    end
  end

  Template.register_tag(Tags::DialogueTag::TAG_NAME, Tags::DialogueTag)
end
