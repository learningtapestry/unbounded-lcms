module DocTemplate
  module Tags
    class ActivityMetadataTypeTag < BaseTag
      TAG_NAME = 'activity-metadata-type'.freeze
      TEMPLATE = 'activity.html.erb'.freeze

      def parse(node, opts = {})
        activity = opts[:activity].level2_by_title(opts[:value])
        activity_src =
          [].tap do |result|
            while (sibling = node.next_sibling)
              break if sibling.content =~ /\[\s*(#{ActivityMetadataSectionTag::TAG_NAME}|#{ActivityMetadataTypeTag::TAG_NAME}|#{MaterialsTag::TAG_NAME})/i
              result << sibling.to_html
              sibling.remove
            end
          end.join
        activity_src = parse_nested(activity_src, opts)
        activity[:activity_guidance] = strip_html_element(activity[:activity_guidance])
        @result = node.replace(parse_template({ source: activity_src, activity: activity }, TEMPLATE))
        self
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataTypeTag::TAG_NAME, Tags::ActivityMetadataTypeTag)
end
