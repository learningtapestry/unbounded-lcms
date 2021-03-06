# frozen_string_literal: true

class AddAltNamesToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :alt_names, :text, array: true, default: [], null: false
  end
end
