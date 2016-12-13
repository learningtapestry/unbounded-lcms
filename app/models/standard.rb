class Standard < ActiveRecord::Base
  mount_uploader :language_progression_file, LanguageProgressionFileUploader

  has_many :content_guide_standards
  has_many :content_guides, through: :content_guide_standards
  has_many :resource_standards
  has_many :resources, through: :resource_standards

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

  scope :bilingual, ->{ where(is_language_progression_standard: true) }
end
