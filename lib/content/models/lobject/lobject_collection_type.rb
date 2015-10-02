module Content
  module Models
    class LobjectCollectionType < ActiveRecord::Base
      include Normalizable

      ELA_CURRICULUM_MAP_NAME  = 'ELA Curriculum Map'
      MATH_CURRICULUM_MAP_NAME = 'Math Curriculum Map'

      has_many :lobject_collections, dependent: :nullify

      validates :name, presence: true, uniqueness: { case_sensitive: false }

      default_scope { order(:name) }

      normalize_attr :name, -> (value) { value.strip }

      def self.curriculum_maps
        where(name: [ELA_CURRICULUM_MAP_NAME, MATH_CURRICULUM_MAP_NAME])
      end
    end
  end
end
