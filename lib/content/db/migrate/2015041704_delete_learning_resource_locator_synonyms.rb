class DeleteLearningResourceLocatorSynonyms < ActiveRecord::Migration
  def change
    drop_table :learning_resource_locator_synonyms
  end
end
