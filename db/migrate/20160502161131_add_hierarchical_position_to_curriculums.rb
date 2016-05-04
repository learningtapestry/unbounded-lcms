class AddHierarchicalPositionToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :hierarchical_position, :string, index: true
  end
end
