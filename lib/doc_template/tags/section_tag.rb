# frozen_string_literal: true

module DocTemplate
  module Tags
    class SectionTag < BaseTag
      STUDENT_RE = /^\s*student\s*resources\s*$/i
      TAG_NAME = 'section'
      TEMPLATE_ELA = 'ela-2-6-section.html.erb'
      TEMPLATE = 'section.html.erb'
      TEMPLATE_SM = 'ela-headings.html.erb'

      def parse(node, opts = {})
        @opts = opts
        section = @opts[:agenda].level2_by_title(@opts[:value].parameterize)
        # TODO: need to be refactored, maybe wrap all structure tags with content
        # into divs (or sections) with css classes, will be easy to iterate and
        # split document into chunks
        # Anyway line below is for build ela2 tm/sm for now
        return parse_ela2_sm(node, section) if ela2?(@opts[:metadata]) && student_material?(section)
        return parse_ela(node, section) if ela2?(@opts[:metadata]) && section.use_color
        return parse_ela(node, section) if ela6?(@opts[:metadata])


        @content = parse_template section, TEMPLATE
        replace_tag node
        self
      end

      private

      def parse_ela(node, section)
        params = {
          content: fetch_nodes_content(node),
          section: section
        }
        parsed_template = parse_template(params, TEMPLATE_ELA)
        @content = parse_nested parsed_template, @opts
        replace_tag node
        self
      end

      def parse_ela2_sm(node, section)
        content = content_until_break(node)

        params = {
          content: parse_nested(content, @opts),
          heading: parse_template(section, TEMPLATE),
          tag: 'ela2-sm'
        }
        @content = parse_template params, TEMPLATE_SM
        replace_tag node
        self
      end

      def fetch_nodes_content(node)
        nodes = [].tap do |result|
          while (node = node.next_sibling)
            break if include_break?(node)
            result << node
          end
        end

        nodes.each(&:remove).map(&:to_html).join
      end

      def student_material?(section)
        section.title =~ STUDENT_RE
      end
    end
  end

  Template.register_tag(Tags::SectionTag::TAG_NAME, Tags::SectionTag)
end
