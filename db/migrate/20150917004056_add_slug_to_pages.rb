# frozen_string_literal: true

class AddSlugToPages < ActiveRecord::Migration
  def change
    add_column :pages, :slug, :string, null: false
  end
end
