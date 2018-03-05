# frozen_string_literal: true

class AddPdfToLessonDocuments < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :pdf, :string
  end
end
