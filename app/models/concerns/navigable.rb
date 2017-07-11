require 'active_support/concern'

module Navigable
  extend ActiveSupport::Concern

  included do
    def parents
      @parents ||= begin
        depth = CurriculumTree::HIERARCHY.index(curriculum_type.to_sym)
        [].tap do |result|
          CurriculumTree::HIERARCHY.each_with_index do |type, idx|
            next if idx >= depth
            res = self.class.tree
                    .where(curriculum_type: type)
                    .where_curriculum(curriculum[0..idx])
                    .ordered.first
            result << res if res
          end
        end
      end
    end

    def parent
      parents.last
    end

    def children
      @children ||= begin
        next_level = CurriculumTree.next_level(curriculum_type)
        self.class.tree
          .where_curriculum(curriculum)
          .where(curriculum_type: next_level)
          .ordered
      end
    end

    def siblings
      @siblings ||= subject? ? self.class.tree.subjects.ordered : parent.children
    end

    def previous
      @previous ||= begin
        level_position = nil
        siblings.each_with_index do |res, index|
          if res.id == id
            level_position = index
            break
          end
        end
        return nil unless level_position

        if level_position > 0
          siblings[level_position - 1]
        else
          # last element of previous node from parent level
          parent.try(:previous).try(:children).try(:last)
        end
      end
    end

    def next
      @next ||= begin
        level_position = nil
        siblings.each_with_index do |res, index|
          if res.id == id
            level_position = index
            break
          end
        end
        return nil unless level_position

        if level_position < siblings.size - 1
          siblings[level_position + 1]
        else
          # first element of next node from parent level
          parent.try(:next).try(:children).try(:first)
        end
      end
    end
  end
end
