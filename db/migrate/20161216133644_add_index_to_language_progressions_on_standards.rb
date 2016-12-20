class AddIndexToLanguageProgressionsOnStandards < ActiveRecord::Migration
  def change
    add_index :standards, :is_language_progression_standard
  end
end
