# frozen_string_literal: true

class RemoveClusterFromStandards < ActiveRecord::Migration
  def change
    remove_column :standards, :cluster
  end
end
