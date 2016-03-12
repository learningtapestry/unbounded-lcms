class ChangeNameInStandards < ActiveRecord::Migration
  def change
    change_column :standards, :name, :string, null: false
  end
end
