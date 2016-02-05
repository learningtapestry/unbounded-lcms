class ChangeLobjects < ActiveRecord::Migration
  def change
    change_table :lobjects do |t|
      t.boolean :hidden, index: true, default: false
    end
  end
end
