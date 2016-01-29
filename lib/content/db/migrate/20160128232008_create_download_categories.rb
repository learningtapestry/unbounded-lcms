class CreateDownloadCategories < ActiveRecord::Migration
  def change
    create_table :download_categories do |t|
      t.string :name, null: false
      t.string :description
    end
  end
end
