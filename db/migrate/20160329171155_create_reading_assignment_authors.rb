class CreateReadingAssignmentAuthors < ActiveRecord::Migration
  def change
    create_table :reading_assignment_authors do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :reading_assignment_authors, :name, unique: true
  end
end
