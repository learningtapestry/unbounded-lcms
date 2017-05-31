class ResourceSerializer < ActiveModel::Serializer
  include TruncateHtmlHelper
  include ResourceHelper

  self.root = false

  attributes :id, :title, :short_title, :teaser, :time_to_teach, :type, :path,
             :downloads, :subject, :grade, :breadcrumb_title, :copyright,
             :has_related

  def id
    object.id
  end

  def ld_metadata
    return nil unless object.document?
    @ld_metadata ||= DocumentPresenter.new(object.document).ld_metadata
  end

  def title
    ld_metadata.try(:title) || object.title
  end

  def short_title
    object.short_title
  end

  def teaser
    ld_metadata.try(:teaser) || object.teaser
  end

  def time_to_teach
    object.time_to_teach
  end

  def type
    object.curriculum_type
  end

  def subject
    object.subject
  end

  def grade
    object.grades.average
  end

  def breadcrumb_title
    Breadcrumbs.new(object).title
  end

  def path
    return document_path(object.document) if object.document?
    show_resource_path(object)
  end

  def downloads
    indent = object.pdf_downloads?
    serialize_download = lambda do |download|
      {
        id: download.id,
        icon: h.file_icon(download.download.attachment_content_type),
        title: download.download.title,
        url: download_path(download, slug: object.slug),
        preview_url: preview_download_path(id: download, slug: object.slug),
        indent: indent
      }
    end
    object.download_categories.map { |k, v| [k, v.map(&serialize_download)] }
  end

  def copyright
    copyrights_text(object)
  end

  def has_related # rubocop:disable Style/PredicateName
    # based on 'find_related_instructions' method from 'ResourcesController'
    object.unbounded_standards.any? do |standard|
      standard.content_guides.exists? || standard.resources.media.exists?
    end
  end

  protected

  def h
    ApplicationController.helpers
  end
end
