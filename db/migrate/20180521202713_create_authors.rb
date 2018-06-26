# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
