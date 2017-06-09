module DocTemplate
  module Tags
    class WhitePlaceholderTag < BaseTag
      END_VALUE = 'end'.freeze
      TAG_NAME = 'white-placeholder'.freeze
      TEMPLATE = 'white-placeholder.html.erb'.freeze

      def parse(node, opts = {})
        if opts[:value] == END_VALUE
          node.remove
        else
          nodes = fetch_content node

          content = nodes.map do |n|
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
          node = node.replace parse_template(params, TEMPLATE)
        end

        @result = node
        self
      end

      private

      def fetch_content(node)
        re = /\[#{TAG_NAME}:\s*#{END_VALUE}\]/
        [].tap do |result|
          while (node = node.next_sibling)
            node.remove && break if node.content.downcase.index(re).present?
            result << node
          end
        end
      end

      def fetch_title(data)
        css_class, title = (data.presence || '').split(';').map(&:strip)
        unless css_class.casecmp('colored').zero?
          title = css_class
          css_class = nil
        end
        [css_class, title]
      end
    end
  end

  Template.register_tag(Tags::WhitePlaceholderTag::TAG_NAME, Tags::WhitePlaceholderTag)
end
