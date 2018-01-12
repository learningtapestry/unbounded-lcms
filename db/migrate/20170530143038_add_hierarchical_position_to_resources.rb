class AddHierarchicalPositionToResources < ActiveRecord::Migration
  def change
    add_column :resources, :hierarchical_position, :string, index: true
  end

  # def data
  #   GenerateHierarchicalPositions.new.generate!
  # end
end
