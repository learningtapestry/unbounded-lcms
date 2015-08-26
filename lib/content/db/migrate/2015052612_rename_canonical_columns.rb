class RenameCanonicalColumns < ActiveRecord::Migration
  def change
    rename_column :keywords, :canonical_id, :parent_id
    rename_column :urls, :canonical_id, :parent_id
  end
end
