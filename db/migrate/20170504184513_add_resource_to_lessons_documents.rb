# frozen_string_literal: true

class AddResourceToLessonsDocuments < ActiveRecord::Migration
  def change
    add_reference :lesson_documents, :resource, index: true
  end
end
