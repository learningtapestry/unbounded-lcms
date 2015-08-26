class DropLobjectTitleDescription < ActiveRecord::Migration
  def change
    change_table :lobjects do |t|
      t.remove :title
      t.remove :description
    end
  end
end
