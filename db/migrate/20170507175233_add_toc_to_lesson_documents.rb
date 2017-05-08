class AddTocToLessonDocuments < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :toc, :jsonb
  end
end
