class ChangeLearningObjectIdentitiesRenameType < ActiveRecord::Migration
  def change
    rename_column :learning_object_identities, :type, :identity_type
  end
end
