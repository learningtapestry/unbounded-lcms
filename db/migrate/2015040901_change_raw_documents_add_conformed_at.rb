class ChangeRawDocumentsAddConformedAt < ActiveRecord::Migration
  def change
    change_table :raw_documents do |t|
      t.timestamp :conformed_at
    end
  end
end
