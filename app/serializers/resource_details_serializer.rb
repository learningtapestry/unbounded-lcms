# frozen_string_literal: true

# This is a superset of ResourceSerializer, meant to be used were we need
# associations and other info. Currently is used on ExploreCurriculums
# (together with the CurriculumResourceSerializer)
class ResourceDetailsSerializer < ResourceSerializer
  include ResourceHelper

  self.root = false

  attributes :breadcrumb_title, :copyright, :downloads, :grade, :has_related, :id,
             :opr_description, :path, :short_title, :subject, :teaser, :time_to_teach,
             :title, :type

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

  private

  def h
    ApplicationController.helpers
  end
end
