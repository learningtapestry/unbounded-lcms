# frozen_string_literal: true

class AddDescriptionToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :description, :string
  end
end
