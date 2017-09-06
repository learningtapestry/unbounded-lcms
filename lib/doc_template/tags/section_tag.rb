# frozen_string_literal: true

module DocTemplate
  module Tags
    class SectionTag < BaseTag
      include DocTemplate::Tags::Helpers

      STUDENT_RE = /^\s*student\s*resources\s*$/i
      TAG_NAME = 'section'
      TEMPLATES = {
        default: 'section.html.erb',
        gdoc: 'gdoc/section.html.erb'
      }.freeze

      def parse(node, opts = {})
        @opts = opts
        @section = opts[:agenda].level2_by_title(opts[:value].parameterize)
        @anchor = @section.anchor
        @materials = @section.material_ids
        @content = parse_general_content node, template_name(opts)
        replace_tag node
        self
      end

      private

      attr_reader :opts, :section

      def general_params
        @params ||= {
          placeholder: placeholder_id,
          priority_description: priority_description(section),
          react_props: {
            activity: {
              title: section.title
            },
            material_ids: @section.material_ids
          },
          section: section
        }
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
