class AddIndexToUserOrganizations < ActiveRecord::Migration
  def change
    add_index :user_organizations, [:user_id, :organization_id], unique: true
  end
end
