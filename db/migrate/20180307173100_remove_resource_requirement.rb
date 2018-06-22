class RemoveResourceRequirement < ActiveRecord::Migration
  def change
    drop_table :resource_requirements do |t|
      t.integer :resource_id, null: false, index: true
      t.integer :requirement_id, null: false

      t.timestamps
    end
  end
end
