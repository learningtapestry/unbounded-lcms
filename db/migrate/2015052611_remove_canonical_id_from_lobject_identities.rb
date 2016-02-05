class RemoveCanonicalIdFromLobjectIdentities < ActiveRecord::Migration
  def change
    change_table :lobject_identities do |t|
      t.remove :canonical_id
    end
  end
end
