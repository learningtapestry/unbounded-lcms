class AddSlugToResources < ActiveRecord::Migration
  def change
    add_column :resources, :slug, :string, index: true
  end

  def data
    Slug.generate_resources_slugs
  end
end
