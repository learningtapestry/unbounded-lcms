class CurriculumType < ActiveRecord::Base
  has_many :curriculums

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  default_scope { order(:name) }
end
