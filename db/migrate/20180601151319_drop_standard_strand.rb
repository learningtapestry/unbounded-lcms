class DropStandardStrand < ActiveRecord::Migration
  def change
    remove_column :standards, :standard_strand_id, :integer
    drop_table :standard_strands do |t|
      t.string :name, null: false
      t.string :heading
    end
  end
end
