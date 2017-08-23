# frozen_string_literal: true

module DocTemplate
  module Tags
    class SectionTag < BaseTag
      include DocTemplate::Tags::Helpers

      STUDENT_RE = /^\s*student\s*resources\s*$/i
      TAG_NAME = 'section'
      TEMPLATE_ELA = 'section-ela-2-6.html.erb'
      TEMPLATE = 'section.html.erb'
      TEMPLATE_SM = 'section-ela-sm.html.erb'

      def parse(node, opts = {})
        @opts = opts
        @section = opts[:agenda].level2_by_title(opts[:value].parameterize)
        @materials = @section.material_ids

        return parse_ela2_sm(node) if ela2?(opts[:metadata]) && section.title =~ STUDENT_RE
        return parse_ela(node) if ela2?(opts[:metadata]) && @section.use_color
        return parse_ela(node) if ela6?(opts[:metadata])

        @content = parse_general_content node, TEMPLATE
        replace_tag node
        self
      end

      private

      attr_reader :opts, :section

      def general_params
        @params ||= {
          placeholder: placeholder_id,
          react_props: {
            activity: {
              title: section.title
            },
            material_ids: @section.material_ids
          },
          section: section
        }
      end

      def parse_ela(node)
        @content = parse_general_content node, TEMPLATE_ELA
        replace_tag node
        self
      end

      def parse_ela2_sm(node)
        content = content_until_break node

        params = general_params.merge(
          content: parse_nested(content, opts),
          tag: 'ela2-sm'
        )
        @content = parse_template params, TEMPLATE_SM
        replace_tag node
        self
      end

      def parse_general_content(node, template)
        params = general_params.merge(
          content: content_until_break(node)
        )
        parsed_template = parse_template(params, template)
        parse_nested parsed_template, opts
      end
    end
  end

  Template.register_tag(Tags::SectionTag::TAG_NAME, Tags::SectionTag)
end
