class RenameLessonDocumentToDocument < ActiveRecord::Migration
  def change
    rename_table :lesson_documents, :documents
  end
end
