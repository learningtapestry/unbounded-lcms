module DocTemplate
  module Tags
    class TablePreserveAlignmentTag < BaseTag
      STYLE_RE = /text-align:(left|center|right)/i
      TAG_NAME = 'table-preserve-alignment'.freeze

      def parse(node, _ = {})
        if (table = find_table node)
          # inside cells for each `p` with `text-align` css param we add specific class
          table.xpath('.//p').each do |el|
            if (m = STYLE_RE.match el['style'])
              el['style'] = el['style'].sub STYLE_RE, ''
              el['class'] = "text-#{m[1]}"
            end
          end

          node = node.replace table
        else
          node.remove
        end

        @result = node
        self
      end

      private

      def find_table(node)
        while (node = node.next_sibling)
          return node if node.name.casecmp('table').zero?
        end
      end
    end

    Template.register_tag(Tags::TablePreserveAlignmentTag::TAG_NAME, TablePreserveAlignmentTag)
  end
end
