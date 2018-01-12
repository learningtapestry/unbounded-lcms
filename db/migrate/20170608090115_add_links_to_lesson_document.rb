class AddLinksToLessonDocument < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :links, :hstore, default: ''
  end
end
