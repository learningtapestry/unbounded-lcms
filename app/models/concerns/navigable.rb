require 'active_support/concern'

module Navigable
  extend ActiveSupport::Concern

  included do
    def parents
      ancestors.reverse
    end

    def previous
      @previous ||= begin
        return nil unless level_position

        if level_position > 0
          siblings.where(level_position: level_position - 1).first
        else
          # last element of previous node from parent level
          parent.try(:previous).try(:children).try(:last)
        end
      end
    end

    def next
      @next ||= begin
        return nil unless level_position

        if level_position < siblings.size
          siblings.where(level_position: level_position + 1).first
        else
          # first element of next node from parent level
          parent.try(:next).try(:children).try(:first)
        end
      end
    end
  end
end
