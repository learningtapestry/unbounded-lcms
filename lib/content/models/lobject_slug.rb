module Content::Models
  class LobjectSlug < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :lobject_collection

    validates :lobject, :value, presence: true
    validates :value, uniqueness: { case_sensitive: false, scope: :lobject_collection }
  end
end
