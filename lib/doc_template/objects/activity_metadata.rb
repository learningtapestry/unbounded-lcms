module DocTemplate
  module Objects
    class ActivityMetadata
      include Virtus.model
      include DocTemplate::Objects::TocHelpers

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
        attribute :anchor, String, default: ->(a, _) { "#{a.idx} #{a.activity_title}".parameterize }
        attribute :idx, Integer
        attribute :level, Integer, default: 2
        attribute :active, Boolean, default: false
      end

      class Section
        include Virtus.model

        attribute :time, Integer, default: 0
        attribute :title, String
        attribute :children, Array[Activity]

        attribute :anchor, String, default: ->(a, _) { "#{a.idx} #{a.title}".parameterize }
        attribute :level, Integer, default: 1
        attribute :idx, Integer
        attribute :active, Boolean, default: false
      end

      attribute :children, Array[Section]
      attribute :idx, Integer

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
        new(set_index(children: activity_data))
      end
    end
  end
end
