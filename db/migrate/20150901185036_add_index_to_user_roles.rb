class AddIndexToUserRoles < ActiveRecord::Migration
  def change
    add_index :user_roles, [:user_id, :organization_id, :role_id], unique: true
  end
end
