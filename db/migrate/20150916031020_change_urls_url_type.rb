class ChangeUrlsUrlType < ActiveRecord::Migration
  def change
    change_column :urls, :url, :text, null: false
  end
end
