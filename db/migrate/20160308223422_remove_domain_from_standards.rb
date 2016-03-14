class RemoveDomainFromStandards < ActiveRecord::Migration
  def change
    remove_column :standards, :domain
  end
end
