# frozen_string_literal: true

module DocTemplate
  module Tags
    class ActivityMetadataTypeTag < BaseTag
      TAG_NAME = 'activity-metadata-type'
      TASK_RE = /(\[task:\s(#)\])/i
      TEMPLATE = 'activity.html.erb'

      def parse(node, opts = {})
        @metadata = opts[:activity]
        activity = @metadata.level2_by_title(opts[:value])
        activity[:activity_guidance] = strip_html_element(activity[:activity_guidance])

        content = content_until_break node
        content = parse_nested content.to_s, opts
        params = {
          activity: activity,
          content: content,
          placeholder: placeholder_id,
          priority_description: priority_description(activity)
        }
        @content = parse_template params, TEMPLATE
        replace_tag node
        self
      end

      private

      def handle_tasks_for(activity, html)
        return html unless TASK_RE =~ html

        next_task_id = @metadata.task_counter[activity.activity_type].to_i + 1
        @metadata.task_counter[activity.activity_type] = next_task_id

        html.sub(/\[task:\s#\]/i, "[task: #{next_task_id}]")
      end

      def priority_description(activity)
        return unless activity.activity_priority.present?
        config = self.class.config[TAG_NAME.downcase]
        config['priority_descriptions'][activity.activity_priority - 1]
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataTypeTag::TAG_NAME, Tags::ActivityMetadataTypeTag)
end
