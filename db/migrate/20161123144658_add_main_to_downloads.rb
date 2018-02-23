# frozen_string_literal: true

class AddMainToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :main, :boolean, null: false, default: false
  end
end
