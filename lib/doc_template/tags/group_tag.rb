module DocTemplate
  module Tags
    class GroupTag < BaseTag
      TAG_NAME  = 'group'.freeze
      OPT_BREAK = '[optbreak]'.freeze
      TEMPLATE  = 'h2-header.html.erb'.freeze

      def parse(node, opts = {})
        group = opts[:agenda].level1_by_title(opts[:value].parameterize)
        return parse_ela6(node, group, opts) if ela6?(opts[:metadata])
        node.replace(parse_template(group, TEMPLATE))
        @result = node
        self
      end

      private

      def parse_ela6(node, group, opts)
        table = node.ancestors('table')
        # check if there is OptBreak before group
        opts[:agenda].add_break(group) if opt_break?(node)
        @result = table.before(parse_template(group, TEMPLATE))
        # remove table if it was last group without sections in a table
        node.ancestors('tr').first.next_element ? node.remove : table.remove
        self
      end

      def opt_break?(node)
        prev = node.ancestors('tr').first.previous_element
        return false unless prev.present?
        result = prev.inner_html =~ /#{Regexp.escape(OPT_BREAK)}/
        prev.remove if result
        result
      end
    end
  end

  Template.register_tag(Tags::GroupTag::TAG_NAME, Tags::GroupTag)
end
