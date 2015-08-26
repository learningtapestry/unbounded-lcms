module Content
  class LobjectRelatedLobject < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :related_lobject, class_name: 'Content::Lobject', foreign_key: 'related_lobject_id'
  end
end
