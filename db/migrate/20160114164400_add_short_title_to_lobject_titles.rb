class AddShortTitleToLobjectTitles < ActiveRecord::Migration
  def change
    add_column :lobject_titles, :short_title, :string
  end
end
