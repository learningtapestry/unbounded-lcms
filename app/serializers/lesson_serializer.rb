class LessonSerializer < ActiveModel::Serializer
  include TruncateHtmlHelper
  include ResourceHelper

  self.root = false

  attributes :id, :title, :short_title, :description, :estimated_time, :type, :path

  def description
    truncate_html(object.description, length: 200) if object.description
  end

  def estimated_time
    42
  end

  def type
    :lesson
  end

  def path
    show_resource_path(object)
  end

end
