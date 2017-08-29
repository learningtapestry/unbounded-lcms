class RemoveContentFromMaterials < ActiveRecord::Migration
  def change
    remove_column :materials, :content, :text
  end
end
