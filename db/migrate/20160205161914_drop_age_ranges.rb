class DropAgeRanges < ActiveRecord::Migration
  def change
    drop_table :lobject_age_ranges
  end
end
