# frozen_string_literal: true

module DocTemplate
  module Objects
    class TOCMetadata
      include Virtus.model

      class Heading
        include Virtus.model

        attribute :anchor, String
        attribute :children, Array[Heading], default: []
        attribute :level, Integer
        attribute :material_ids, Array[Integer], default: []
        attribute :standard, String, default: ''
        attribute :time, Integer, default: 0
        attribute :title, String
        attribute :priority, Integer, default: 0

        def excluded?(excludes)
          return false unless excludes.present?
          excludes.include?(anchor) || (children.present? && children.all? { |c| c.excluded?(excludes) })
        end

        def time_with(excludes)
          return 0 if excludes&.include?(anchor)
          return time if children.blank? || excludes.blank?
          children.sum { |c| c.time_with(excludes) }
        end
      end

      attribute :children, Array[Heading], default: []
      attribute :priority, Integer, default: 0
      attribute :total_time, Integer, default: ->(t, _) { t.children.sum(&:time) }

      class << self
        def dump(data)
          data.to_json
        end

        def load(data)
          new(data)
        end
      end

      def append(toc)
        children.concat toc.children
        update_time
      end

      def prepend(toc)
        children.unshift(*toc.children)
        update_time
      end

      def total_time_with(excludes)
        return total_time unless excludes.present?
        children.sum { |c| c.time_with(excludes) }
      end

      private

      def update_time
        self.total_time = children.sum(&:time)
      end
    end
  end
end
