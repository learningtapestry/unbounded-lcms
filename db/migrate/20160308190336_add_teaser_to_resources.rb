# frozen_string_literal: true

class AddTeaserToResources < ActiveRecord::Migration
  def change
    add_column :resources, :teaser, :string
  end
end
