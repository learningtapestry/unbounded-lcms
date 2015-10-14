module Content
  module Models
    class LobjectChild < ActiveRecord::Base
      belongs_to :lobject_collection, inverse_of: :lobject_children
      belongs_to :parent, class_name: 'Content::Models::Lobject', foreign_key: 'parent_id'
      belongs_to :child, class_name: 'Content::Models::Lobject', foreign_key: 'child_id'

      alias_attribute :collection, :lobject_collection

      validates :child, :lobject_collection, :parent, :position, presence: true
      validates :child, uniqueness: { scope: 'lobject_collection_id' }
    end
  end
end
