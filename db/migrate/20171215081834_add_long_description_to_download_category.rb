# frozen_string_literal: true

class AddLongDescriptionToDownloadCategory < ActiveRecord::Migration
  def change
    add_column :download_categories, :long_description, :text
  end
end
