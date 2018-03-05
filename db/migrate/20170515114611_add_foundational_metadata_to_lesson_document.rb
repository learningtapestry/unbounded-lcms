# frozen_string_literal: true

class AddFoundationalMetadataToLessonDocument < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :foundational_metadata, :hstore
  end
end
