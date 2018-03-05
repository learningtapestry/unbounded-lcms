class RemoveResourceBackup < ActiveRecord::Migration
  def change
    drop_table :resource_backups do |t|
      t.string :comment, null: false
      t.string :dump

      t.timestamps null: false
    end
  end
end
