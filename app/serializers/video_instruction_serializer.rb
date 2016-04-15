class VideoInstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :teaser, :img, :path

  def short_title
    "short title Video"
  end

  def img
    "#"
  end

  def path
    "#"
  end
end
