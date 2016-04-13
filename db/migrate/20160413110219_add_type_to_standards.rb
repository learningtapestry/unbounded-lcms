class AddTypeToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :type, :string
    add_index :standards, :type
  end
end
