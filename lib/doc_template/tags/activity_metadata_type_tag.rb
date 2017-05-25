module DocTemplate
  module Tags
    class ActivityMetadataTypeTag < BaseTag
      TAG_NAME = 'activity-metadata-type'.freeze
      TASK_RE = /(\[task:\s(#)\])/i
      TEMPLATE = 'activity.html.erb'.freeze

      def parse(node, opts = {})
        activity = opts[:activity].level2_by_title(opts[:value])
        activity_src =
          [].tap do |result|
            while (sibling = node.next_sibling)
              break if sibling.content =~ /\[\s*(#{ActivityMetadataSectionTag::TAG_NAME}|#{ActivityMetadataTypeTag::TAG_NAME}|#{MaterialsTag::TAG_NAME})/i

              # Substitutes task tags
              html = handle_tasks_for activity, sibling.to_html

              result << html
              sibling.remove
            end
          end.join
        activity_src = parse_nested(activity_src, opts)
        activity[:activity_guidance] = strip_html_element(activity[:activity_guidance])
        @result = node.replace(parse_template({ source: activity_src, activity: activity }, TEMPLATE))
        self
      end

      private

      def handle_tasks_for(activity, html)
        return html unless TASK_RE =~ html

        activity[:task_count] += 1
        html.sub /\[task:\s#\]/i, "[task: #{activity[:task_count]}]"
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataTypeTag::TAG_NAME, Tags::ActivityMetadataTypeTag)
end
