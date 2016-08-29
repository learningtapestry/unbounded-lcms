class CurriculumResourceSerializer < ActiveModel::Serializer
  include TruncateHtmlHelper
  include ResourceHelper

  self.root = false

  attributes :id,
    :curriculum_id,
    :title,
    :short_title,
    :teaser,
    :time_to_teach,
    :type,
    :path,
    :downloads,
    :subject,
    :grade,
    :breadcrumb_title,
    :copyright,
    :has_related

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

  def time_to_teach
    object.resource.time_to_teach
  end

  def type
    object.curriculum_type
  end

  def subject
    object.resource.subject
  end

  def grade
    object.grade_color_code
  end

  def path
    show_resource_path(object.resource, object)
  end

  def downloads
    object.resource.downloads.map do |download|
      {
        id: download.id,
        icon: h.file_icon(download.attachment_content_type),
        title: download.title,
        url: download_path(download, slug_id: object.try(:slug).try(:id)),
      }
    end
  end

  def copyright
    cc_descriptions = []
    object.copyrights.each do |copyright|
      cc_descriptions << copyright.value.strip if copyright.value.present?
    end
    object.copyrights.pluck(:disclaimer).uniq.each do |disclaimer|
      cc_descriptions << disclaimer.strip if disclaimer.present?
    end
    cc_descriptions.join(' ')
  end

  def has_related
    # based on 'find_related_instructions' method from 'ResourcesController'
    object.resource.unbounded_standards.any? do |standard|
      standard.content_guides.exists? || standard.resources.media.exists?
    end
  end

  protected

    def h
      ApplicationController.helpers
    end
end
