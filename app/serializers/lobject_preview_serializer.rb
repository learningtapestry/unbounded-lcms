class LobjectPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :curriculum_subject, :resource_kind, :slug
  include TruncateHtmlHelper

  def description
    truncate_html(object.description, length: 300) if object.description
  end

  def resource_kind
    object.unbounded_curriculum.try(:resource_kind)
  end

  def title
    title    = object.title.present? ? object.title : nil
    subtitle = object.subtitle.present? ? object.subtitle : nil
    [title, subtitle].compact.join(': ')
  end
end
