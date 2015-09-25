require 'content/models/concerns/canonicable'

module Content
  module Models  
    class Alignment < ActiveRecord::Base
      include Canonicable

      has_many :lobject_alignments

      default_scope { order(:name) }

      def self.by_organization(organization)
        joins(lobject_alignments: [:lobject]).where(
          'lobjects.organization_id' => organization.id
        )
      end

      def self.by_grade(grade)
        self.by_grades([grade])
      end

      def self.by_grades(grades)
        joins(lobject_alignments: { lobject: [:grades] }).where(
          'grades.id' => grades.map(&:id)
        )
      end

      def self.by_curriculum(curriculum)
        collection_ids = Lobject
          .find_curriculum_lobjects(curriculum)
          .map { |lob| lob.curriculum_map_collection.id }

        joins(lobject_alignments: { lobject: [:lobject_children] }).where(
          'lobject_children.lobject_collection_id' => collection_ids
        )
      end
    end
  end
end
