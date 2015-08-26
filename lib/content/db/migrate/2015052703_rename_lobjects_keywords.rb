class RenameLobjectsKeywords < ActiveRecord::Migration
  def change
    rename_table :lobjects_keywords, :lobject_keywords
  end
end
