class AddDomainToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :domain, :string, index: true
    add_index :standards, :domain
  end
end
