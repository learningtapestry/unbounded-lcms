class Standard < ActiveRecord::Base
  has_many :resource_standards
  belongs_to :standard_cluster
  belongs_to :standard_domain
  belongs_to :standard_strand

  default_scope { order(:name) }

  scope :by_grade, ->(grade) {
    self.by_grades([grade])
  }

  scope :by_grades, ->(grades) {
    joins(resource_standards: { resource: [:grades] }).where(
      'grades.id' => grades.map(&:id)
    )
  }

  scope :by_collection, ->(collection) {
    self.by_collection([collection])
  }

  scope :by_collections, ->(collections) {
    joins(resource_standards: { resource: [:resource_children] }).where(
      'resource_children.resource_collection_id' => collections.map(&:id)
    )
  }

  scope :ela, ->{ where(subject: 'ela') }
  scope :math, ->{ where(subject: 'math') }
end