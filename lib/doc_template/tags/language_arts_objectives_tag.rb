module DocTemplate
  module Tags
    class LanguageArtsObjectivesTag < BaseTag
      END_VALUE = 'end'.freeze
      TAG_NAME = 'language arts objectives'.freeze
      TEMPLATE = 'language_arts_objectives.html.erb'.freeze

      def parse(node, opts = {})
        if opts[:value] == END_VALUE
          node.remove
        else
          nodes = block_nodes(node)
          content = parse_nested nodes.map(&:to_html).join
          nodes.each(&:remove)
          node = node.replace "<div class='o-ld-language_arts_objectives'>#{content}</div>"
        end

        template = File.read template_path(TEMPLATE)
        node.before ERB.new(template).result(binding)
        @result = node
        self
      end

      private

      def block_nodes(node)
        # we have to collect all nodes until the we find the end tag
        end_regexp = /\[#{TAG_NAME}:\s*#{END_VALUE}\]/
        [].tap do |result|
          while (node = node.next_sibling)
            break if node.content.downcase =~ end_regexp
            result << node
          end
        end
      end

    end
  end

  Template.register_tag(Tags::LanguageArtsObjectivesTag::TAG_NAME, Tags::LanguageArtsObjectivesTag)
end
