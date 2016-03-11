class AddEllAppropriateToResources < ActiveRecord::Migration
  def change
    add_column :resources, :ell_appropriate, :boolean, null: false, default: false
  end
end
