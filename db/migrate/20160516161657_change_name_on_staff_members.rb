class ChangeNameOnStaffMembers < ActiveRecord::Migration
  def change
    remove_column :staff_members, :name, :string

    add_column :staff_members, :first_name, :string
    add_column :staff_members, :last_name, :string
    add_column :staff_members, :order, :integer
  end
end
