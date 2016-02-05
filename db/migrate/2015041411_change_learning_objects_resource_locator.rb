class ChangeLearningObjectsResourceLocator < ActiveRecord::Migration
  def change
    change_table :learning_objects do |t|
      t.remove :resource_locator
      t.references :learning_resource_locator, references: :learning_resource_locators
    end
  end
end
