class InstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :subject, :teaser, :img, :path, :instruction_type, :grade_avg

  def title
    h.simple_format(object.title)
  end

  def subject
    object.subject.try(:downcase) || 'default'
  end

  def img
    object.try(:small_photo).try(:url) || placeholder
  end

  def placeholder
    h.image_path('cg_placeholder.jpg')
  end

  def path
    id = object.permalink.presence || object.id
    content_guide_path(id, object.slug)
  end

  def instruction_type
    :instruction
  end

  def grade_avg
    object.grades.average
  end

  private

  def h
    ActionController::Base.helpers
  end
end
