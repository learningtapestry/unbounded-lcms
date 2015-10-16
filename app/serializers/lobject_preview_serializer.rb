class LobjectPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :curriculum_subject

  def description
    object.description.truncate(300, separator: ' ') if object.description
  end
end
