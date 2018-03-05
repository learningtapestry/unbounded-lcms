# frozen_string_literal: true

class RemoveDomainFromStandards < ActiveRecord::Migration
  def change
    remove_column :standards, :domain
  end
end
