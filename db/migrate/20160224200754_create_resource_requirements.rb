class CreateResourceRequirements < ActiveRecord::Migration
  def change
    create_table :resource_requirements do |t|
      t.integer :resource_id, null: false, index: true
      t.integer :requirement_id, null: false

      t.timestamps
    end
  end
end
