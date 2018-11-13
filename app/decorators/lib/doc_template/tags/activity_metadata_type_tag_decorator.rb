# frozen_string_literal: true

module DocTemplate
  module Tags
    ActivityMetadataTypeTag.class_eval do
      def build_params(content)
        {
          activity: @activity,
          content: HtmlSanitizer.strip_html_element(content),
          foundational: opts[:foundational_skills],
          placeholder: placeholder_id,
          priority_description: priority_description(@activity),
          priority_icon: priority_icon(@activity),
          react_props: {
            activity: {
              title: @activity.title,
              type: @activity.activity_type
            },
            material_ids: @activity.material_ids
          }
        }
      end
    end
  end
end