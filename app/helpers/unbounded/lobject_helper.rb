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

    def module_node_title(module_node)
      t('unbounded.curriculum.module_title', idx: module_node.position + 1)
    end

    def unit_node_title(unit_node)
      t('unbounded.curriculum.unit_title', idx: unit_node.position + 1)
    end

    def module_node_ui_units(module_node)
      module_node.children.inject(0) { |total, unit_node|
        total + (unit_node.children.size/16.0).ceil
      }
    end

    def module_class(module_node)
      ui_units = module_node_ui_units(module_node)
      if ui_units <= 3
        'module-6'
      else
        'module-12'
      end
    end

    def file_icon(type)
      type == 'pdf' ? type: 'doc'
    end

    def resource_icon(lobject)
      resource_types = lobject.resource_types.pluck(:name)
      resource_types.include?('video') ? 'video' : 'resource'
    end

    def sidebar_nav_link(curriculum, link_obj)
      link_obj.present? ? unbounded_resource_path(curriculum, link_obj) : '#'
    end

    def lobject_presenter(lobject)
      yield LobjectPresenter.new(lobject)
    end

    def unbounded_resource_path(curriculum, resource)
      slug = resource.slug_for_collection(curriculum.collection)

      if slug
        "/resources/#{slug}"
      else
        unbounded_show_path(resource)
      end
    end
  end
end
