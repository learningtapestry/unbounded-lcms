class RemoveAltNameFromStandards < ActiveRecord::Migration
  def change
    remove_column :standards, :alt_name
  end
end
