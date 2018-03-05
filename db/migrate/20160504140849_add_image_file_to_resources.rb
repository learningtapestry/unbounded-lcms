# frozen_string_literal: true

class AddImageFileToResources < ActiveRecord::Migration
  def change
    add_column :resources, :image_file, :string
  end
end
