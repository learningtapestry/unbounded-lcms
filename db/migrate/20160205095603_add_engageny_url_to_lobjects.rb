class AddEngagenyUrlToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :engageny_url, :string
  end
end
