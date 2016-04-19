class InstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :short_title, :teaser, :img, :path

  def short_title
    "#{object.subject.titleize} #{object.grade.titleize} Content Guide"
  end

  def img
    object.small_photo.try(:path)
  end

  def path
    content_guide_path(object)
  end

  def instruction_type
    :instruction
  end

end
