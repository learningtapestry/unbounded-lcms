class InstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :short_title, :subject, :teaser, :img, :path, :instruction_type

  def short_title
    subject_title = object.subject.try(:titleize) || ''
    "#{subject_title} Content Guide".strip
  end

  def subject
    object.try(:subject).downcase || 'default'
  end

  def img
    # object.small_photo.try(:path)
    # TODO fix-me when we add photos/images to Content Guides
    ActionController::Base.helpers.image_path('placeholder_white_bg.svg')
  end

  def path
    content_guide_path(object)
  end

  def instruction_type
    :instruction
  end

end
