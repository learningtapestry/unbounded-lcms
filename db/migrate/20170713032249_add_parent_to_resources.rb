class AddParentToResources < ActiveRecord::Migration
  def change
    add_column :resources, :parent_id, :integer
    add_column :resources, :level_position, :integer
  end
end
