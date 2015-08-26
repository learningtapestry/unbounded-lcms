require 'content/models'

class AddNameToIdentities < ActiveRecord::Migration
  def change
    change_table :identities do |t|
      t.string :name
    end

    Content::Identity.update_all('name = description, description = NULL')
  end
end
