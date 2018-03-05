# frozen_string_literal: true

class RemoveContentFromDocuments < ActiveRecord::Migration
  def change
    remove_column :documents, :content, :text
  end
end
