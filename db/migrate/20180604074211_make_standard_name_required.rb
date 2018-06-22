# frozen_string_literal: true

class MakeStandardNameRequired < ActiveRecord::Migration
  def up
    change_column :standards, :name, :string, null: false
    change_column :standards, :subject, :string, null: true
  end

  def down; end
end
