# frozen_string_literal: true

module DocTemplate
  module Objects
    class ActivityMetadata
      include Virtus.model
      include DocTemplate::Objects::TocHelpers

      class Activity
        include Virtus.model

        SEPARATOR = /\s*[,;]\s*/

        attribute :activity_type, String
        attribute :activity_title, String
        attribute :activity_source, String
        attribute :activity_source_materials, String
        attribute :activity_materials, String
        attribute :activity_standard, String
        attribute :activity_mathematical_practice, String
        attribute :activity_time, Integer, default: 0
        attribute :activity_priority, Integer, default: 0
        attribute :activity_metacognition, String
        attribute :activity_guidance, String
        attribute :activity_content_development_notes, String

        # aliases to build toc
        attribute :active, Boolean, default: false
        attribute :anchor, String, default: ->(a, _) { "#{a.idx} #{a.activity_title}".parameterize }
        attribute :idx, Integer
        attribute :level, Integer, default: 2
        attribute :priority, Integer, default: ->(a, _) { a.activity_priority }
        attribute :title, String, default: ->(a, _) { a.activity_title }
        attribute :time, Integer, default: ->(a, _) { a.activity_time }

        attribute :material_ids, Array[Integer], default: []

        def activity_standard_info
          [activity_standard, activity_mathematical_practice]
            .flat_map { |x| x.to_s.split(SEPARATOR) }
            .map(&:strip)
            .reject(&:blank?)
            .uniq
            .map { |x| { description: Standard.search_by_name(x).take&.description, standard: x } }
        end
      end

      class Section
        include Virtus.model

        attribute :children, Array[Activity]
        attribute :time, Integer, default: 0
        attribute :title, String

        # aliases to build toc
        attribute :active, Boolean, default: false
        attribute :anchor, String, default: ->(a, _) { "#{a.idx} #{a.title}".parameterize }
        attribute :idx, Integer
        attribute :level, Integer, default: 1
      end

      attribute :children, Array[Section]
      attribute :idx, Integer
      attribute :task_counter, Hash[String => Integer], default: {}

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

      def add_break
        idx = children.index { |c| !c.active } || -1
        section = Section.new(title: 'Foundational Skills Lesson', anchor: 'optbreak', time: 0, children: [])
        children.insert(idx - 1, section)
      end
    end
  end
end
