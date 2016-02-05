class ChangeRawDocumentsChangeParsed < ActiveRecord::Migration
  def change
    change_table :raw_documents do |t|
      t.remove :parsed
      t.timestamp :format_parsed_at
    end
  end
end
