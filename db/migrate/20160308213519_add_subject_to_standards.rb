class AddSubjectToStandards < ActiveRecord::Migration
  def change
    add_column :standards, :subject, :string
    add_index :standards, :subject
  end
end
