class ResourceChild < ActiveRecord::Base
  belongs_to :resource_collection, inverse_of: :resource_children
  belongs_to :parent, class_name: 'Resource', foreign_key: 'parent_id'
  belongs_to :child, class_name: 'Resource', foreign_key: 'child_id'

  alias_attribute :collection, :resource_collection

  validates :child, :resource_collection, :parent, :position, presence: true
  validates :child, uniqueness: { scope: 'resource_collection_id' }
end
