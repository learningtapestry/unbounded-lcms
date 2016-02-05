class ChangeLearningObjectsRemoveLocator < ActiveRecord::Migration
  def change
    change_table :learning_objects do |t|
      t.remove :learning_resource_locator_id
    end
  end
end
