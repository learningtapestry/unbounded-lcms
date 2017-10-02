# frozen_string_literal: true

module DocTemplate
  module Tags
    class ActivityMetadataSectionTag < BaseTag
      TAG_NAME = 'activity-metadata-section'
      TEMPLATES = { default: 'group-math.html.erb',
                    gdoc:    'gdoc/group-math.html.erb' }.freeze

      def parse(node, opts = {})
        section = opts[:sections].level1_by_title(opts[:value])
        @anchor = section.anchor

        if opts[:value] == 'foundational-skills'
          # Extend object to store `lesson_objective` (#162)
          section.class.attribute :lesson_objective, String
          section.lesson_objective = strip_html_element(opts[:foundational_metadata].lesson_objective)
          # Extend object to store `lesson_standard` (#386)
          section.class.attribute :lesson_standard, String
          section.lesson_standard = strip_html_element(opts[:foundational_metadata].lesson_standard)
          opts[:sections].add_break
          opts[:foundational_skills] = true
        end

        content = content_until_break node
        content.scan(FULL_TAG).select { |t| t.first == ActivityMetadataTypeTag::TAG_NAME }.each do |(_, a)|
          section.add_activity opts[:activity].find_by_anchor(a)
        end
        content = parse_nested content.to_s, opts
        params = {
          content: content,
          foundational_skills: opts[:foundational_skills],
          placeholder: placeholder_id,
          section: section
        }
        @content = parse_template params, template_name(opts)
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataSectionTag::TAG_NAME, Tags::ActivityMetadataSectionTag)
end
