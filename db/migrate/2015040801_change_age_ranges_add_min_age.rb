class ChangeAgeRangesAddMinAge < ActiveRecord::Migration
  def change
    change_table :age_ranges do |t|
      t.boolean :min_age, default: false
    end
  end
end
