module DocTemplate
  module Tags
    class MaterialsTag < BaseTag
      # BREAK_TAG_NAME = 'break'.freeze
      TAG_NAME = 'materials'.freeze
      TEMPLATE = 'materials.html.erb'.freeze

      def parse(node, opts = {})
        # we have to collect all the next siblings until next activity-metadata
        content = [].tap do |result|
          while (sibling = node.next_sibling) do
            break if include_break?(sibling.content)
            result << sibling.to_html
            sibling.remove
          end
        end.join

        node.replace(parse_template(parse_nested(content, opts), TEMPLATE))
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::MaterialsTag::TAG_NAME, Tags::MaterialsTag)
end
