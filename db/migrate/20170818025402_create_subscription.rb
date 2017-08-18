class CreateSubscription < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
