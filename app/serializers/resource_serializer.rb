class ResourceSerializer < ActiveModel::Serializer
  include TruncateHtmlHelper

  self.root = false

  attributes :id, :title, :description, :short_title, :subtitle, :teaser, :type, :link

  def teaser
    truncate_html(object.description, length: 200) if object.description
  end

  def type
    object.curriculums.first.try(:curriculum_type).try(:name)
  end

  def link
    # TODO implement-me
    '#'
  end
end
