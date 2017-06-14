module DocTemplate
  module Tags
    class ActivityMetadataTypeTag < BaseTag
      TAG_NAME = 'activity-metadata-type'.freeze
      TASK_RE = /(\[task:\s(#)\])/i
      TEMPLATE = 'activity.html.erb'.freeze

      def parse(node, opts = {})
        @metadata = opts[:activity]
        activity = @metadata.level2_by_title(opts[:value])

        activity_src =
          [].tap do |result|
            while (sibling = node.next_sibling)
              break if include_break?(sibling)

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

        next_task_id = @metadata.task_counter[activity.activity_type].to_i + 1
        @metadata.task_counter[activity.activity_type] = next_task_id

        html.sub /\[task:\s#\]/i, "[task: #{next_task_id}]"
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataTypeTag::TAG_NAME, Tags::ActivityMetadataTypeTag)
end
