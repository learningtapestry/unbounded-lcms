class AddNameIndexToStandards < ActiveRecord::Migration
  def change
    add_index :standards, :name
  end
end
