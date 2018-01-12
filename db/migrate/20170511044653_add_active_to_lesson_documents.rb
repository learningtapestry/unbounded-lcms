class AddActiveToLessonDocuments < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :active, :boolean, default: true, null: false
  end
end
