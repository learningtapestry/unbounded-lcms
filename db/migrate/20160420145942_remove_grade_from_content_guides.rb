# frozen_string_literal: true

class RemoveGradeFromContentGuides < ActiveRecord::Migration
  def change
    remove_column :content_guides, :grade, :string
  end
end
