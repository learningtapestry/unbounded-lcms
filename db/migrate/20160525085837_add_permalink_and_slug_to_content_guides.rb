class AddPermalinkAndSlugToContentGuides < ActiveRecord::Migration
  def change
    add_column :content_guides, :permalink, :string
    add_column :content_guides, :slug, :string

    add_index :content_guides, :permalink, unique: true
  end
end
