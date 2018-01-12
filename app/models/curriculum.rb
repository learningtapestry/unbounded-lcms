# Legacy Curriculum model. After we stabilize the new version after the
# refactor, we should remove this and associated models (like CurriculumType, etc).
#
# We're using the library `closure_tree`, which gives us handy methods to deal
# with trees.
# See: https://github.com/mceachen/closure_tree#accessing-data
#
class Curriculum < ActiveRecord::Base
  acts_as_tree order: 'position', dependent: :destroy

  belongs_to :parent, class_name: 'Curriculum', foreign_key: 'parent_id'
  belongs_to :seed, class_name: 'Curriculum', foreign_key: 'seed_id'

  belongs_to :curriculum_type

  belongs_to :item, polymorphic: true, autosave: true
  belongs_to :resource_item, class_name: 'Resource', foreign_key: 'item_id', foreign_type: 'Resource'
  belongs_to :curriculum_item, class_name: 'Curriculum', foreign_key: 'item_id', foreign_type: 'Curriculum'

  has_many :referrers, class_name: 'Curriculum', as: 'item', dependent: :destroy

  scope :with_resources, -> { joins(:resource_item).where(item_type: 'Resource') }

  scope :seeds, -> { where(seed_id: nil) }
  scope :trees, -> { where.not(seed_id: nil) }

  def resource
    if item_type == 'Resource'
      item
    elsif item_type == 'Curriculum'
      item.item
    end
  end
end
