class CurriculumType < ActiveRecord::Base
  has_many :curriculums

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  default_scope { order(:name) }

  def self.grade; @grade ||= find_by(name: 'grade'); end
  def self.module; @module ||= find_by(name: 'module'); end
  def self.unit; @unit ||= find_by(name: 'unit'); end
  def self.lesson; @lesson ||= find_by(name: 'lesson'); end
  def self.map; @map ||= find_by(name: 'map'); end
end
