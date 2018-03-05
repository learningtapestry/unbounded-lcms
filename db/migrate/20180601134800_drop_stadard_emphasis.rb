class DropStadardEmphasis < ActiveRecord::Migration
  def change
    drop_table :standard_emphases do |t|
      t.references :standard, null: false, index: true, foreign_key: true
      t.string     :emphasis, null: false
      t.string     :grade
    end
  end
end
