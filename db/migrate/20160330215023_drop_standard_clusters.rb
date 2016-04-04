class DropStandardClusters < ActiveRecord::Migration
  def change
    remove_column :standards, :standard_cluster_id
    drop_table :standard_clusters
  end
end
