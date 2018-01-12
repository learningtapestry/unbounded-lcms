class AddAgendaToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :agenda_metadata, :jsonb
  end
end
