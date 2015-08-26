class CreateLobjectTitles < ActiveRecord::Migration
  def change
    create_table :lobject_titles do |t|
      t.string :title
      t.belongs_to :lobject
      t.timestamps
    end
  end
end
