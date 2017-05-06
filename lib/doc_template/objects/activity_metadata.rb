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
    end

    class Section
      include Virtus.model

      attribute :time, Integer, default: 0
      attribute :section_title, String
      attribute :activities, Array[Activity]
    end

    attribute :groups, Array[Section]

    def self.build_from(data)
      activity_data =
        data.each { |d| d.transform_keys! { |k| k.to_s.underscore } }
            .group_by { |d| d['section_title'] }
            .map do |section, activity|
              activity.each do |a|
                a['activity_time'] = '0' unless a.key?('activity_time')
                a['activity_time'] = a['activity_time'][/\d+/].to_i || 0
              end
              { section_title: section,
                time: activity.sum { |a| a['activity_time'] },
                activities: activity }
            end
      new(groups: activity_data)
    end

    def section_by_tag(title)
      groups.find { |s| s.section_title.parameterize == title }
    end

    def activity_by_tag(title)
      groups.each do |s|
        next unless title.starts_with?(s.section_title.parameterize)
        activity = s.activities.find do |a|
          "#{s.section_title} #{a.activity_title}".parameterize == title
        end
        return activity if activity
      end
    end
  end
end
