class VideoInstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :short_title, :teaser, :img, :path

  def short_title
    object.short_title || default_short_title
  end

  def default_short_title
    "#{object.subject.titleize} #{object.grades.first.try(:name).try(:titleize)} Video"
  end

  def img
    "#"
  end

  def path
    "#"
  end
end
