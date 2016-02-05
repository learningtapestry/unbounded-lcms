class CreateLearningObjects < ActiveRecord::Migration
  def change
    create_table :learning_objects do |t|
      t.string  :description
      t.string  :title
      t.string  :resource_locator

      t.timestamps
    end

    add_index :learning_objects, :resource_locator
  end
end
