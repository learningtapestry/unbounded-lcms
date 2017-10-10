# frozen_string_literal: true

module DocTemplate
  module Objects
    class SectionsMetadata
      include Virtus.model
      include DocTemplate::Objects::TocHelpers

      class Activity
        include Virtus.model

        # aliases to build toc
        attribute :active, Boolean, default: false
        attribute :anchor, String
        attribute :idx, Integer
        attribute :level, Integer, default: 2
        attribute :priority, Integer, default: ->(a, _) { a.activity_priority }
        attribute :standard, String, default: ->(s, _) { s.activity_standard }
        attribute :title, String, default: ->(a, _) { a.activity_title }
        attribute :time, Integer, default: ->(a, _) { a.activity_time }
      end

      class Section
        include Virtus.model
        include DocTemplate::Objects::MetadataHelpers

        attribute :children, Array[Activity]
        attribute :summary, String
        attribute :time, Integer, default: 0
        attribute :title, String

        # aliases to build toc
        attribute :active, Boolean, default: false
        attribute :anchor, String, default: ->(a, _) { "#{a.idx} #{a.title}".parameterize }
        attribute :idx, Integer
        attribute :level, Integer, default: 1

        def add_activity(activity)
          self.time += activity.time.to_i
          activity.active = true
          children << activity
        end

        def section_standard_info
          standard_info lesson_standard
        end
      end

      attribute :children, Array[Section]
      attribute :idx, Integer

      def self.build_from(data, foundational_metadata = nil)
        sections = data.map do |metadata|
          metadata.transform_keys { |k| k.to_s.gsub('section-', '').underscore }
        end
        sections << { title: 'Foundational Skills', anchor: 'foundational-skills' } if foundational_metadata.present?
        new(set_index(children: sections))
      end

      def add_break
        idx = children.index { |c| !c.active } || -1
        section = Section.new(title: 'Foundational Skills Lesson', anchor: 'optbreak', time: 0, children: [])
        children.insert(idx - 1, section)
      end
    end
  end
end
