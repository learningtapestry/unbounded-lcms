class VideoInstructionSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false
  attributes :id, :title, :short_title, :subtitle, :subject, :teaser, :img, :path, :instruction_type, :time_to_teach

  def short_title
    object.short_title || default_short_title
  end

  def subject
    object.try(:subject).downcase || 'default'
  end

  def default_short_title
    "#{object.subject.titleize} #{object.grades.first.try(:name).try(:titleize)} #{instruction_type.try(:titleize)}"
  end

  def img
    # TODO fix-me when we add photos/images to Resources
    ActionController::Base.helpers.image_path('placeholder_white_bg.svg')
  end

  def time_to_teach
    # TODO fix-me when we add photos/images to Resources
    60
  end

  def path
    media_path(object.id)
  end

  def instruction_type
    object.video? ? :video : :podcast
  end
end
