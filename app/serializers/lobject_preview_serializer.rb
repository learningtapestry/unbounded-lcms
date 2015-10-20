class LobjectPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :curriculum_subject, :resource_kind
  include TruncateHtmlHelper

  def description
    truncate_html(object.description, length: 300) if object.description
  end

  def resource_kind
    object.unbounded_curriculum.try(:resource_kind)
  end
end
