class ChangeLobjectAgeRanges < ActiveRecord::Migration
  def change
    change_table :lobject_age_ranges do |t|
      t.remove :age
      t.remove :min_age
      t.integer :min_age
      t.integer :max_age
      t.boolean :extended_age
    end
  end
end
