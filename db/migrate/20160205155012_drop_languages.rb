class DropLanguages < ActiveRecord::Migration
  def change
    drop_table :lobject_languages
    drop_table :languages
  end
end
