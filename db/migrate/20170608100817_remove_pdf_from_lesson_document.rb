# frozen_string_literal: true

class RemovePdfFromLessonDocument < ActiveRecord::Migration
  def change
    remove_column :lesson_documents, :pdf
  end
end
