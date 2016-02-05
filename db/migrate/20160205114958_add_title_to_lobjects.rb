class AddTitleToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :title, :string
  end
end
