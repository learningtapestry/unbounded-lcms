class LessonSerializer < ActiveModel::Serializer
  include TruncateHtmlHelper
  self.root = false

  attributes :id, :title, :short_title, :description, :estimated_time, :type

  def description
    truncate_html(object.description, length: 200) if object.description
  end

  def estimated_time
    42
  end

  def type
    :lesson
  end

end
