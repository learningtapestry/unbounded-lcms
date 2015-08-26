class RemoveUserCategories < ActiveRecord::Migration
  def change
    remove_column :document_subjects, :user_category_id
    remove_column :lobject_subjects, :user_category_id
    drop_table :user_categories
  end
end
