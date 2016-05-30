class InstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :subject, :teaser, :img, :path, :instruction_type

  def title
    ActionController::Base.helpers.simple_format(object.title)
  end

  def subject
    object.subject.try(:downcase) || 'default'
  end

  def img
    object.try(:small_photo).try(:url) || ActionController::Base.helpers.image_path('cg_placeholder.jpg')
  end

  def path
    id = object.permalink.present? ? object.permalink : object.id
    content_guide_path(id, object.slug)
  end

  def instruction_type
    :instruction
  end

end
