# frozen_string_literal: true

class AddSubtitleToLobjects < ActiveRecord::Migration
  def change
    add_column :lobjects, :subtitle, :string
  end
end
