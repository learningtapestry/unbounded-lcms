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

    def unit_title(curriculum)
      subject = curriculum.subject
      units = curriculum.units
      unit  = curriculum.current_unit
      idx = units.index(unit)
      t("unbounded.curriculum.#{subject}_unit_label", idx: idx + 1)
    end

    def module_node_title(module_node)
      subject = module_node.content.curriculum_subject
      t("unbounded.curriculum.#{subject}_module_label", idx: module_node.position + 1)
    end

    def unit_node_title(unit_node)
      subject = unit_node.content.curriculum_subject
      t("unbounded.curriculum.#{subject}_unit_label", idx: unit_node.position + 1)
    end

    def module_node_ui_units(module_node)
      module_node.children.inject(0) { |total, unit_node|
        total + (unit_node.children.size/16.0).ceil
      }
    end

    def previous_module_node(module_node)
      grade_node = module_node.parent
      position = grade_node.children.index(module_node)
      if position > 0
        grade_node.children[position-1]
      else
        nil
      end
    end

    def next_module_node(module_node)
      grade_node = module_node.parent
      position = grade_node.children.index(module_node)
      grade_node.children[position+1]
    end

    def fits_in_half?(module_node)
      module_node_ui_units(module_node) <= 3
    end

    def each_with_module_class(modules)
      mod_classes = []

      is_first_item = true
      modules.each do |mod|
        klass = 'module-12'

        if fits_in_half?(mod)
          if is_first_item
            next_mod = next_module_node(mod)
            if next_mod && fits_in_half?(next_mod)
              mod_units, next_mod_units = module_node_ui_units(mod), module_node_ui_units(next_mod)
              both_empty = mod_units == 0 && next_mod_units == 0
              none_empty = mod_units > 0 && next_mod_units > 0
              klass = 'module-6' if (both_empty || none_empty) 
            end
          else
            klass = 'module-6' if fits_in_half?(previous_module_node(mod))
          end
        end

        is_first_item = !is_first_item if klass == 'module-6'
        mod_classes << [mod, klass]
      end

      mod_classes.each { |(mod, klass)| yield mod, klass }
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
