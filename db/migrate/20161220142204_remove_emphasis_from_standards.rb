# frozen_string_literal: true

class RemoveEmphasisFromStandards < ActiveRecord::Migration
  def change
    remove_column :standards, :emphasis
  end
end
