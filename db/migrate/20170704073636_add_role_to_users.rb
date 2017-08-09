class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: 0, null: false
  end

  def data
    User.where(admin: true).update_all(role: 1)
  end
end
