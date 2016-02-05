class ChangeKeywordsAddCanonical < ActiveRecord::Migration
  def change
    change_table :keywords do |t|
      t.references :canonical, references: :keywords
    end

    add_index :keywords, :canonical_id
  end
end
