class CreateUserOrganizations < ActiveRecord::Migration
  def change
    create_table :user_organizations do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :organization, index: true, foreign_key: true, null: false
    end
  end
end
