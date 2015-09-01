class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :description
    end
  end
end
