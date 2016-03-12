class AddStandardClusterIdToStandards < ActiveRecord::Migration
  def change
    add_reference :standards, :standard_cluster, index: true, foreign_key: true
  end
end
