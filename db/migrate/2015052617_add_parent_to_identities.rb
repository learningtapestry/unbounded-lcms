class AddParentToIdentities < ActiveRecord::Migration
  def change
    change_table :identities do |t|
      t.references :parent, references: :identities
    end
  end
end
