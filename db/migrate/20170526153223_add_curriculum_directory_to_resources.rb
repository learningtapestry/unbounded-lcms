class AddCurriculumDirectoryToResources < ActiveRecord::Migration
  def change
    add_column :resources, :curriculum_type, :string, index: true
    add_column :resources, :curriculum_directory, :text, array: true, default: [], null: false, index: true

    add_reference :resources, :curriculum_tree, index: true
  end

  def data
    # ensure we have the curriculum tree loaded
    if CurriculumTree.where(default: true).empty?
      require_relative '../data/curriculum_tree_migrator'
      CurriculumTreeMigrator.new.migrate!
    end

    require_relative '../data/curriculum_directory_migrator'
    CurriculumDirectoryMigrator.new.migrate!
  end
end
