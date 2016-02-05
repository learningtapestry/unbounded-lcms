class DropOrganizations < ActiveRecord::Migration
  def change
    remove_column :lobjects, :organization_id
    drop_table :user_organizations
    drop_table :organizations
  end
end
