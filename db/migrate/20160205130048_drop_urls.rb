class DropUrls < ActiveRecord::Migration
  def change
    drop_table :lobject_urls
    drop_table :urls
  end
end
