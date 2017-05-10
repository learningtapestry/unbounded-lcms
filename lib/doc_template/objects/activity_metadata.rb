module DocTemplate
  class ActivityMetadata
    include Virtus.model

    class Activity
      include Virtus.model

      attribute :activity_type, String
      attribute :activity_title, String
      attribute :activity_source, String
      attribute :activity_materials, String
      attribute :activity_standard, String
      attribute :activity_mathematical_practice, String
      attribute :activity_time, Integer, default: 0
      attribute :activity_priority, Integer, default: 0
      attribute :activity_metacognition, String
      attribute :activity_guidance, String
      attribute :activity_content_development_notes, String

      # aliases to build toc
      attribute :title, String, default: ->(a, _) { a.activity_title }
      attribute :time, Integer, default: ->(a, _) { a.activity_time }
      attribute :id, String, default: ->(a, _) { a.activity_title.parameterize }
      attribute :level, Integer, default: 2
    end

    class Section
      include Virtus.model

      attribute :time, Integer, default: 0
      attribute :title, String
      attribute :children, Array[Activity]

      attribute :id, String, default: ->(a, _) { a.title.parameterize }
      attribute :level, Integer, default: 1
    end

    attribute :groups, Array[Section]

    def self.build_from(data)
      activity_data =
        data.each { |d| d.transform_keys! { |k| k.to_s.underscore } }
            .group_by { |d| d['section_title'] }
            .map do |section, activity|
              activity.each { |a| a['activity_time'] = a['activity_time'].to_s[/\d+/].to_i }
              {
                children: activity,
                time: activity.sum { |a| a['activity_time'] },
                title: section
              }
            end
      new(groups: activity_data)
    end

    def section_by_tag(title)
      groups.find { |s| s.title.parameterize == title }
    end

    def activity_by_tag(title)
      groups.each do |s|
        next unless title.starts_with?(s.title.parameterize)
        activity = s.children.find do |a|
          "#{s.title} #{a.activity_title}".parameterize == title
        end
        return activity if activity
      end
    end
  end
end
