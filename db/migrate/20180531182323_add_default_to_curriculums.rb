# frozen_string_literal: true

class AddDefaultToCurriculums < ActiveRecord::Migration
  def change
    add_column :curriculums, :default, :boolean, null: false, default: false
  end
end
