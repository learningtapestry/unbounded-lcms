class AddHttpStatusToLearningResourceLocators < ActiveRecord::Migration
  def change
    change_table :learning_resource_locators do |t|
      t.integer :http_status
      t.timestamp :checked_at
    end
  end
end
