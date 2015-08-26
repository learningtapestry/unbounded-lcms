class CreateLearningResourceLocators < ActiveRecord::Migration
  def change
    create_table :learning_resource_locators do |t|
      t.string :url
      t.timestamps
    end
  end
end
