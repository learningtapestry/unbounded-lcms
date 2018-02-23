# frozen_string_literal: true

class AddTitleToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :title, :string
  end
end
