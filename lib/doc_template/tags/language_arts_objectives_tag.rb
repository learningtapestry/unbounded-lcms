module DocTemplate
  module Tags
    class LanguageArtsObjectivesTag < BlockTag
      TAG_NAME = 'language arts objectives'.freeze
      TEMPLATE = 'language_arts_objectives.html.erb'.freeze

      def parse(node, opts = {})
        nodes = block_nodes node
        nodes.each(&:remove)

        params = {
          content: parse_nested(nodes.map(&:to_html).join, opts)
        }
        @result = node.replace parse_template params, TEMPLATE
        self
      end
    end
  end

  Template.register_tag(Tags::LanguageArtsObjectivesTag::TAG_NAME, Tags::LanguageArtsObjectivesTag)
end
