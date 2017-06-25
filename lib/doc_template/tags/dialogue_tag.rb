module DocTemplate
  module Tags
    class DialogueTag < BlockTag
      include ERB::Util

      TAG_NAME = 'dialogue'.freeze
      TEMPLATE = 'dialogue.html.erb'.freeze

      def parse(node, _ = {})
        @tags = []

        nodes = block_nodes node
        nodes.map(&:remove)

        params = { phrases: format_phrases(nodes) }
        @result = node.replace parse_template(params, TEMPLATE)
        self
      end

      private

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
