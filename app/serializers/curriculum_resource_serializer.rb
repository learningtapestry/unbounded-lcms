class CurriculumResourceSerializer < ActiveModel::Serializer
  include TruncateHtmlHelper
  include ResourceHelper

  self.root = false

  attributes :id,
    :curriculum_id,
    :title,
    :short_title,
    :teaser,
    :description,
    :text_description,
    :estimated_time,
    :type,
    :path

  def id
    object.resource.id
  end

  def curriculum_id
    object.id
  end

  def title
    object.resource.title
  end

  def short_title
    object.resource.short_title
  end

  def teaser
    object.resource.teaser
  end

  def description
    truncate_html(object.resource.description, length: 200) if object.resource.description
  end

  def text_description
    truncate_html(object.resource.text_description, length: 200)
  end

  def estimated_time
    42
  end

  def type
    object.curriculum_type
  end

  def path
    show_resource_path(object.resource, object)
  end

end
