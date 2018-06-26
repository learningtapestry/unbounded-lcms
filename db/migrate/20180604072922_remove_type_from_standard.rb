# frozen_string_literal: true

class RemoveTypeFromStandard < ActiveRecord::Migration
  def change
    remove_column :standards, :type, :string
  end
end
