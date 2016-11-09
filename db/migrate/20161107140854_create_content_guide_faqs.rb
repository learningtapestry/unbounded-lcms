class CreateContentGuideFaqs < ActiveRecord::Migration
  def change
    create_table :content_guide_faqs do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :subject, null: false, index: true
      t.string :heading, null: false
      t.string :subheading, null: false
      t.boolean :active, default: false, null: false, index: true

      t.timestamps null: false
    end
  end
end
