class VideoInstructionSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false
  attributes :id, :title, :subject, :teaser, :img, :path, :instruction_type

  def subject
    object.subject.try(:downcase) || 'default'
  end

  def img
    # TODO fix-me when we add photos/images to Resources
    ActionController::Base.helpers.image_path('placeholder_white_bg.svg')
  end

  def path
    media_path(object.id)
  end

  def instruction_type
    object.video? ? :video : :podcast
  end
end
