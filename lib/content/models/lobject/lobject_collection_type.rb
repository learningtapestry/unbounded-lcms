module Content
  module Models
    class LobjectCollectionType < ActiveRecord::Base
      include Normalizable

      has_many :lobject_collections, dependent: :nullify

      validates :name, presence: true, uniqueness: { case_sensitive: false }

      default_scope { order(:name) }

      normalize_attr :name, -> (value) { value.strip }
    end
  end
end
