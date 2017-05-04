class AddActivitiesMetadataToLessonDocuments < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :activity_metadata, :jsonb
  end
end
