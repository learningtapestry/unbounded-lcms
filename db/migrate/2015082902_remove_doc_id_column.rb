# frozen_string_literal: true

class RemoveDocIdColumn < ActiveRecord::Migration
  def change
    remove_column :subjects, :doc_id
  end
end
