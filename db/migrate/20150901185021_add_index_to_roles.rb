# frozen_string_literal: true

class AddIndexToRoles < ActiveRecord::Migration
  def change
    add_index :roles, :name, unique: true
  end
end
