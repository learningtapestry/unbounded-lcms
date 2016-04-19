class VideoInstructionSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false
  attributes :id, :title, :short_title, :subtitle, :teaser, :img, :path

  def short_title
    object.short_title || default_short_title
  end

  def default_short_title
    "#{object.subject.titleize} #{object.grades.first.try(:name).try(:titleize)} Video"
  end

  def img
    "#" # TODO fix-me when we add photos/images to Resources
  end

  def path
    show_resource_path(object)
  end

  def type
    :video
  end
end
