class RemoveFrameworkAndFrameworkUrlFromStandards < ActiveRecord::Migration
  def change
    remove_column :standards, :framework
    remove_column :standards, :framework_url
  end
end
