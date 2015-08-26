class ChangeRawDocumentsResourceData < ActiveRecord::Migration
  def change
    change_table :raw_documents do |t|
      t.remove :resource_data_json
      t.remove :resource_data_xml
      t.remove :resource_data_string
      
      t.string :resource_data
    end
  end
end
