class AddOrganizationToLobjects < ActiveRecord::Migration
  def change
    add_reference :lobjects, :organization, index: true, foreign_key: true
  end
end
