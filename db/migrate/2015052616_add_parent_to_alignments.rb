class AddParentToAlignments < ActiveRecord::Migration
  def change
    change_table :alignments do |t|
      t.references :parent, references: :alignments
    end
  end
end
