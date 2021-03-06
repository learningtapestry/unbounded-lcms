# frozen_string_literal: true

class CreateStandardDomains < ActiveRecord::Migration
  def change
    create_table :standard_domains do |t|
      t.string :name, null: false
      t.string :heading
    end
  end
end
