# frozen_string_literal: true

class AddSurveyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :survey, :hstore
  end
end
