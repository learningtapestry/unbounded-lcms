class AddEngagenyTitleToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :engageny_title, :string
  end
end
