class AddFieldsToLessonDocument < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    add_column :lesson_documents, :metadata, :hstore
    add_index :lesson_documents, :metadata, using: :gist
  end
end
