module Content
  module Models
    class LobjectAdditionalLobject < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :additional_lobject, class_name: 'Content::Models::Lobject', foreign_key: 'additional_lobject_id'
    end
  end
end
