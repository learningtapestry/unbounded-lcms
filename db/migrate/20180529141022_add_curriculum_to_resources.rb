# frozen_string_literal: true

class AddCurriculumToResources < ActiveRecord::Migration
  def change
    add_reference :resources, :curriculum, index: true
  end
end
