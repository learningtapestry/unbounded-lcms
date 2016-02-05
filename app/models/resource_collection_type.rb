class ResourceCollectionType < ActiveRecord::Base
  CURRICULUM_MAP_NAME = 'Curriculum Map'

  has_many :resource_collections, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  default_scope { order(:name) }

  def self.curriculum_map; find_by(name: CURRICULUM_MAP_NAME); end

  def curriculum_map?
    name == CURRICULUM_MAP_NAME
  end
end
