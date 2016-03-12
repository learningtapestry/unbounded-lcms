class RenameGoogleDocsTables < ActiveRecord::Migration
  def change
    rename_table :google_doc_definitions, :content_guide_definitions
    rename_table :google_doc_images, :content_guide_images
    rename_table :google_doc_standards, :content_guide_standards
    rename_table :google_docs, :content_guides
  end
end
