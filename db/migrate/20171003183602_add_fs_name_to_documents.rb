# frozen_string_literal: true

class AddFsNameToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :fs_name, :string
  end
end
