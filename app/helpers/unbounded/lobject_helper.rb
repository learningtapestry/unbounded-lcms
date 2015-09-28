module Unbounded
  module LobjectHelper
    include Content::Models

    def language_collection_options
      Language.order(:name).map { |lang| [lang.name, lang.id ] }
    end

    def attachment_content_type(download)
      t("unbounded.content_type.#{download.content_type}") rescue download.content_type
    end

    def attachment_url(download)
      if download.url.present?
        download.url.sub('public://', 'http://k12-content.s3-website-us-east-1.amazonaws.com/')
      else
        download.file.url
      end
    end

    def related_resource_type(lobject)
      resource_types = lobject.resource_types.pluck(:name)

      if resource_types.include?('video')
        t('resource_types.video')
      else
        t('resource_types.resource')
      end
    end

    def lesson_title(title)
      title.split(',').first.gsub(/Module\s+\w+/, '') if title
    end

    def lesson_no(title)
      title.split(',').last if title
    end

    def module_title(title)
      title[/Module\s+\w+/]
    end

    def unit_title(curriculum)
      units = curriculum.units
      unit  = curriculum.current_unit
      idx = units.index(unit)
      t('unbounded.curriculum.unit_title', idx: idx + 1)
    end

    def file_icon(type)
      type == 'pdf' ? type: 'doc'
    end

    def resource_icon(lobject)
      resource_types = lobject.resource_types.pluck(:name)
      resource_types.include?('video') ? 'video' : 'resource'
    end
  end
end
