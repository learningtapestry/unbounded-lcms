class AlterRawDocumentsForTransform < ActiveRecord::Migration
  def change
    change_table :raw_documents do |t|
      t.remove :identity
      t.remove :keys
      t.remove :payload_schema
    end

    change_table :raw_documents do |t|
      t.json :identity
      t.json :keys
      t.json :payload_schema
    end
  end
end

