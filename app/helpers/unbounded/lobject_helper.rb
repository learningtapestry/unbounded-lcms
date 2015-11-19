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

    def grade_name_for_url(grade_lobject)
      grade_lobject.grades.first.grade.gsub(' ', '_')
    end

    def grade_url(curriculum)
      unbounded_curriculum_path(
        subject: curriculum.subject,
        grade: grade_name_for_url(curriculum.current_grade)
      )
    end

    def grade_title(title)
      title.gsub(/Grade\s+\d+/, '') if title
    end

    def grade_subtitle(title)
      " - " + title[/Grade\s+\d+/] if title[/Grade\s+\d+/]
    end

    def lesson_title(title)
      title.split(',').first.gsub(/Module\s+\w+/, '') if title
    end

    def lesson_no(lobject)
      title    = lobject.title.split(',').last rescue nil
      subtitle = lobject.subtitle.present? ? lobject.subtitle : nil
      full_title(title, subtitle)
    end

    def unit_title(curriculum)
      subject = curriculum.subject
      units = curriculum.units
      unit  = curriculum.current_unit
      idx = unit_index(subject, units.index(unit))
      title = t("unbounded.curriculum.#{subject}_unit_label", idx: idx)
      full_title(title, unit.subtitle)
    end

    def module_node_title(module_node)
      subject = module_node.content.curriculum_subject
      title = t("unbounded.curriculum.#{subject}_module_label", idx: module_node.position + 1)
      subtitle = module_node.content.subtitle
      full_title(title, subtitle)
    end

    def unit_node_title(unit_node)
      subject = unit_node.content.curriculum_subject
      idx = unit_index(subject, unit_node.position)
      title = t("unbounded.curriculum.#{subject}_unit_label", idx: idx)
      subtitle = unit_node.content.subtitle
      full_title(title, subtitle)
    end

    def file_icon(type)
      type == 'pdf' ? type: 'doc'
    end

    def resource_icon(lobject)
      resource_types = lobject.resource_types.pluck(:name)
      resource_types.include?('video') ? 'video' : 'resource'
    end

    def sidebar_nav_link(curriculum, link_obj)
      link_obj.present? ? unbounded_resource_path(link_obj, curriculum) : '#'
    end

    def lobject_presenter(lobject)
      yield LobjectPresenter.new(lobject)
    end

    def unbounded_resource_path(resource, curriculum = nil)
      slug = curriculum ? resource.slug_for_collection(curriculum.collection) : resource.slug

      if slug
        unbounded_show_with_slug_path(slug)
      else
        unbounded_show_path(resource.id)
      end
    end

    def all_units_empty?(_module)
      _module.lobject_children.all? { |lc| lc.child.lobject_children.empty? }
    end

    def unit_index(subject, idx)
      idx += 1
      if subject == :math
        result = ''
        while idx > 0
          mod = (idx - 1) % 26
          result = "#{(mod + 65).chr}#{result}"
          idx = (idx - mod) / 26
        end
        result
      else
        idx
      end
    end

    def full_title(title, subtitle)
      if subtitle.present?
        #"<div class='r-title'>#{title}</div><div class='r-subtitle'>#{subtitle}</div>"
        "#{title}: #{subtitle}"
      else
        title
      end
    end
  end
end
