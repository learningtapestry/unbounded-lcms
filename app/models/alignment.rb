class Alignment < ActiveRecord::Base
  has_many :resource_alignments

  default_scope { order(:name) }

  def self.by_grade(grade)
    self.by_grades([grade])
  end

  def self.by_grades(grades)
    joins(resource_alignments: { resource: [:grades] }).where(
      'grades.id' => grades.map(&:id)
    )
  end

  def self.by_collection(collection)
    self.by_collection([collection])
  end

  def self.by_collections(collections)
    joins(resource_alignments: { resource: [:resource_children] }).where(
      'resource_children.resource_collection_id' => collections.map(&:id)
    )
  end
end
