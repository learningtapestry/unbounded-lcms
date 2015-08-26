class RenameAgeRanges < ActiveRecord::Migration
  def change
    rename_table :age_ranges, :conformed_document_age_ranges
  end
end
