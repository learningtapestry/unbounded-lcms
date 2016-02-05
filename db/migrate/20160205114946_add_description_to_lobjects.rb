class AddDescriptionToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :description, :string
  end
end
