# frozen_string_literal: true

class AddCssStylesToLessonDocument < ActiveRecord::Migration
  def change
    add_column :lesson_documents, :css_styles, :text
  end
end
