class InstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :short_title, :teaser, :img, :path

  def short_title
    subject_title = object.subject.try(:titleize) || ''
    "#{subject_title} Content Guide".strip
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
