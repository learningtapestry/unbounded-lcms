class AddTimeToTeachToResources < ActiveRecord::Migration
  def change
    add_column :resources, :time_to_teach, :integer
  end
end
