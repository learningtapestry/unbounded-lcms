# frozen_string_literal: true

class AddAccessCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_code, :string
  end
end
