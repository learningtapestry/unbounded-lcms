class InstructionSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :title, :short_title, :img, :path

  def short_title
    "#{object.subject.titleize} #{object.grade.titleize} Content Guide"
  end

  def img
    object.small_photo.path
  end

  def path
    # h.content_guide_path(object)
    '#'
  end

  protected
    def h
      ApplicationController.helpers
    end
end
