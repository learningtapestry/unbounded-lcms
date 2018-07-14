class RemoveResourceRequirement < ActiveRecord::Migration
  def up
    drop_table :resource_requirements if conn.table_exists? 'resource_requirements'
  end

  def down
    create_table :resource_requirements do |t|
      t.integer :resource_id, null: false, index: true
      t.integer :requirement_id, null: false

      t.timestamps
    end
  end

  def conn
    ActiveRecord::Base.connection
  end
end
