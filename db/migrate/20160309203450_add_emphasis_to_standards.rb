class AddEmphasisToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :emphasis, :string
    add_index :standards, :emphasis
  end
end
