class GenericResourceSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false
  attributes :id, :title, :subject, :teaser, :path, :instruction_type, :time_to_teach

  def subject
    object.subject.try(:downcase) || 'default'
  end

  def path
    generic_path(object)
  end

  def title
    object.resource_type.humanize
  end

  def teaser
    object.title
  end

  def instruction_type
    :generic
  end
end
