class RemoveResourceBackup < ActiveRecord::Migration
  def up
    drop_table :resource_backups if conn.table_exists?('resource_backups')
  end

  def down
    create_table :resource_backups do |t|
      t.string :comment, null: false
      t.string :dump

      t.timestamps null: false
    end
  end

  def conn
    ActiveRecord::Base.connection
  end
end
