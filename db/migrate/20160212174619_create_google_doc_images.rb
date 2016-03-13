class CreateGoogleDocImages < ActiveRecord::Migration
  def change
    create_table :google_doc_images do |t|
      t.string :file, null: false
      t.string :original_url, null: false

      t.timestamps null: false

      t.index :original_url, unique: true
    end
  end
end
