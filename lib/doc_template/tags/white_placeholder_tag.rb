module DocTemplate
  module Tags
    class WhitePlaceholderTag < BlockTag
      TAG_NAME = 'white-placeholder'.freeze
      TEMPLATE = 'white-placeholder.html.erb'.freeze

      def parse(node, opts = {})
        content = block_nodes(node).map do |n|
          n.remove
          n.to_html
        end.join

        css_class, title = fetch_title opts[:value]

        params = {
          content: parse_nested(content, opts),
          css_class: css_class,
          subject: opts[:metadata].subject,
          title: title
        }

        @result = node.replace parse_template(params, TEMPLATE)
        self
      end

      private

      def fetch_title(data)
        css_class, title = (data.presence || '').split(';').map(&:strip)
        unless css_class.to_s.casecmp('colored').zero?
          title = css_class
          css_class = nil
        end
        [css_class, title]
      end
    end
  end

  Template.register_tag(Tags::WhitePlaceholderTag::TAG_NAME, Tags::WhitePlaceholderTag)
end
