# frozen_string_literal: true

class CreateStandardStrands < ActiveRecord::Migration
  def change
    create_table :standard_strands do |t|
      t.string :name, null: false
      t.string :heading
    end
  end
end
