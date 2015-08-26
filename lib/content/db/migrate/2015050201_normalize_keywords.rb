class NormalizeKeywords < ActiveRecord::Migration
  def up
    execute <<-sql
      update
        raw_documents
      set
        keys = lower(keys::text)::jsonb,
        payload_schema = lower(payload_schema::text)::jsonb
    sql
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
