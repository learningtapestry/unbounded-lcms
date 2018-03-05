# frozen_string_literal: true

class AddContentToLessonDocuments < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :content, :text
  end
end
