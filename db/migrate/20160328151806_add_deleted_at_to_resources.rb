class AddDeletedAtToResources < ActiveRecord::Migration
  def change
    add_column :resources, :deleted_at, :datetime
    add_index :resources, :deleted_at
  end
end
