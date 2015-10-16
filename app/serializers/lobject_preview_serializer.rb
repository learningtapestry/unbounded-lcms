class LobjectPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :curriculum_subject, :resource_kind

  def description
    object.description.truncate(300, separator: ' ') if object.description
  end

  def resource_kind
    object.unbounded_curriculum.try(:resource_kind)
  end
end
