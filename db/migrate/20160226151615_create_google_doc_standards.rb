class CreateGoogleDocStandards < ActiveRecord::Migration
  def change
    create_table :google_doc_standards do |t|
      t.string :description, null: false
      t.string :name, null: false

      t.index :name, unique: true
    end
  end
end
