class VideoInstructionSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false
  attributes :id, :title, :subject, :teaser, :img, :path, :instruction_type

  def subject
    object.subject.try(:downcase) || 'default'
  end

  def img
    object.try(:image_file).try(:url) || ActionController::Base.helpers.image_path('resource_placeholder.jpg')
  end

  def path
    media_path(object.id)
  end

  def instruction_type
    object.resource_type
  end
end
