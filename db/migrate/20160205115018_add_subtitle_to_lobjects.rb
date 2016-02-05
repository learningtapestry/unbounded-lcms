class AddSubtitleToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :subtitle, :string
  end
end
