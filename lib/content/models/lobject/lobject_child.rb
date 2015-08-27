module Content
  module Models
    class LobjectChild < ActiveRecord::Base
      belongs_to :lobject_collection
      belongs_to :parent, class_name: 'Content::Lobject', foreign_key: 'parent_id'
      belongs_to :child, class_name: 'Content::Lobject', foreign_key: 'child_id'
      
      alias_attribute :collection, :lobject_collection
    end
  end
end
