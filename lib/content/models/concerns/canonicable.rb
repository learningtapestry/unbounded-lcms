module Content
  module Models
    module Canonicable
      def self.included(base)
        base.class_eval do 
          acts_as_forest
          scope :canonicals, -> { where(parent_id: nil) }
        end

        base.extend(ClassMethods)
      end

      module ClassMethods
        def find_or_create_canonical(attrs)
          find_or_create_by(attrs).canonical
        end
      end

      def canonical
        parent || self
      end

      def chain
        [canonical].concat(canonical.children)
      end
    end
  end
end
