class ChangeLearningResourceLocatorSynonymsRenameSynonym < ActiveRecord::Migration
  def change
    change_table :learning_resource_locator_synonyms do |t|
      t.rename :synonym, :url
    end
  end
end
