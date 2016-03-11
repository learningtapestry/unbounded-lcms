class AddClusterToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :cluster, :string, index: true
    add_index :standards, :cluster
  end
end
