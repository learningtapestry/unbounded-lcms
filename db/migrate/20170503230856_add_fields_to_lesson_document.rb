class AddFieldsToLessonDocument < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :subject, :string
    add_column :lesson_documents, :unit, :string
    add_column :lesson_documents, :grade, :string
    add_column :lesson_documents, :topic, :string
    add_column :lesson_documents, :lesson, :string
    add_column :lesson_documents, :lesson_objective, :string
    add_column :lesson_documents, :lesson_standard, :string
    add_column :lesson_documents, :lesson_mathematial_practice, :string
    add_column :lesson_documents, :relationship_to_eny1, :string
    add_column :lesson_documents, :title, :string
    add_column :lesson_documents, :teaser, :string

    add_column :lesson_documents, :module, :string
    add_column :lesson_documents, :description, :text
    add_column :lesson_documents, :text_title, :string
    add_column :lesson_documents, :text_author, :string
    add_column :lesson_documents, :genre, :string
    add_column :lesson_documents, :text_type, :string
    add_column :lesson_documents, :writing_type, :string
    add_column :lesson_documents, :group_size, :string
    add_column :lesson_documents, :ccss_strand , :string
    add_column :lesson_documents, :ccss_sub_strand , :string
    add_column :lesson_documents, :cc_attribution, :string
    add_column :lesson_documents, :materials, :string
    add_column :lesson_documents, :preparation, :string
  end
end
