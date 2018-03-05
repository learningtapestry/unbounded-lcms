# frozen_string_literal: true

class AddNameIndexToStandards < ActiveRecord::Migration
  def change
    add_index :standards, :name
  end
end
