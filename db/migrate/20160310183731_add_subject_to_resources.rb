class AddSubjectToResources < ActiveRecord::Migration
  def change
    add_column :resources, :subject, :string
  end
end
