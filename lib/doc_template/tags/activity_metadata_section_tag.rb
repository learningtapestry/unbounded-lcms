module DocTemplate
  module Tags
    class ActivityMetadataSectionTag < BaseTag
      TAG_NAME = 'activity-metadata-section'.freeze
      TEMPLATE = 'h2-header.html.erb'.freeze

      def parse(node, opts = {})
        section = opts[:activity].level1_by_title(opts[:value])

        if opts[:value] == 'foundational-skills'
          # Extend object to store `lesson_objective` (#162)
          section.class.attribute :lesson_objective, String
          section.lesson_objective = opts[:foundational_metadata].lesson_objective
          # add break to activities
          opts[:activity].add_break
        end

        node.replace(parse_template(section, TEMPLATE))
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataSectionTag::TAG_NAME, Tags::ActivityMetadataSectionTag)
end
