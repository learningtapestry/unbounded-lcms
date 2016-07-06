class AddPdfToContentGuides < ActiveRecord::Migration
  def change
    add_column :content_guides, :pdf, :string
  end
end
