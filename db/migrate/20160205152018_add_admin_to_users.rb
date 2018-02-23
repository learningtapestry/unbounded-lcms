# frozen_string_literal: true

class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, null: false, default: true
  end
end
