# frozen_string_literal: true

class AddDescriptionToResourceDownload < ActiveRecord::Migration
  def change
    add_column :resource_downloads, :description, :text
  end
end
