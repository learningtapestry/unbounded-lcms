class DropStandardDomains < ActiveRecord::Migration
  def change
    remove_column :standards, :standard_domain_id
    drop_table :standard_domains
  end
end
