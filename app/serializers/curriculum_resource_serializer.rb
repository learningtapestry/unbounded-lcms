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

  def ld_metadata
    return nil unless object.resource.lesson_document?
    @ld_metadata ||= LessonDocumentPresenter.new(object.resource.lesson_document)
                                            .ld_metadata
  end

  def title
    ld_metadata.try(:title) || object.resource.title
  end

  def short_title
    object.resource.short_title
  end

  def teaser
    ld_metadata.try(:teaser) || object.resource.teaser
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
    return lesson_document_path(object.resource.lesson_document) if object.resource.lesson_document?
    show_resource_path(object.resource, object)
  end

  def downloads
    indent = object.resource.pdf_downloads?
    serialize_download = lambda do |download|
      {
        id: download.id,
        icon: h.file_icon(download.download.attachment_content_type),
        title: download.download.title,
        url: download_path(download, slug_id: object.try(:slug).try(:id)),
        preview_url: preview_download_path(id: download,
                                           slug_id: object.try(:slug).try(:id)),
        indent: indent
      }
    end
    object.resource.download_categories.map do |k, v|
      [k, v.map(&serialize_download)]
    end
  end

  def copyright
    copyrights_text(object)
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
