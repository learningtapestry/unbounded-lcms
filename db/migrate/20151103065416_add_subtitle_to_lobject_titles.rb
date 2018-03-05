# frozen_string_literal: true

class AddSubtitleToLobjectTitles < ActiveRecord::Migration
  def change
    add_column :lobject_titles, :subtitle, :string
  end
end
