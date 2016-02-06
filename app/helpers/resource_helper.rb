module ResourceHelper
  def language_collection_options
    Language.order(:name).map { |lang| [lang.name, lang.id ] }
  end

  def attachment_content_type(download)
    case download.content_type
    when 'application/zip' then 'zip'
    when 'application/pdf' then 'pdf'
    when 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' then 'excel'
    when 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation' then 'powerpoint'
    when 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' then 'doc'
    else download.content_type
    end
  end

  def attachment_url(download)
    if download.url.present?
      download.url.sub('public://', 'http://k12-content.s3-website-us-east-1.amazonaws.com/')
    else
      download.file.url
    end
  end

  def related_resource_type(resource)
    resource_types = resource.resource_types.pluck(:name)

    if resource_types.include?('video')
      t('resource_types.video')
    else
      t('resource_types.resource')
    end
  end

  def grade_name_for_url(grade_resource)
    grade_resource.grades.first.grade.gsub(' ', '_')
  end

  def grade_url(curriculum)
    curriculum_path(
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
    title.split(',').first.gsub(/Module\s+\w+/, '').strip if title
  end

  def resource_title(resource, curriculum)
    title     = resource.title
    obj_count = curriculum.current_node.parent.children.size rescue nil

    if obj_count && obj_count > 1 && resource.short_title.blank? && title =~ /\d$/
      t("curriculum.resource_label", title: title, count: obj_count)
    else
      title
    end
  end

  def resource_subtitle(resource)
    resource.subtitle
  end

  def lesson_unit_title(curriculum)
    unit_title(curriculum)
  end

  def lesson_unit_subtitle(resource)
    lesson_title = resource.title.split(',').last rescue nil
    t("curriculum.unit_x_label", lesson: lesson_title)
  end

  def unit_title(curriculum)
    subject = curriculum.subject
    units = curriculum.units
    unit  = curriculum.current_unit
    idx = unit_index(subject, units.index(unit))

    title =
      if (short_title = unit.short_title).present?
        short_title
      else
        t("curriculum.#{subject}_unit_label", idx: idx)
      end

    full_title(title, unit.subtitle)
  end

  def module_title(module_node)
    t = module_node.content.short_title || begin
      subject = module_node.content.curriculum_subject
      t("curriculum.#{subject}_module_label", idx: module_node.position + 1)
    end

    t.gsub('Developing Core Proficiencies Curriculum', 'Core Proficiencies')
  end

  def module_title_class(mod_title)
    if mod_title.size > 10
      'r-title-small'
    else
      'r-title'
    end
  end

  def module_subtitle(module_node)
    module_node.content.subtitle
  end

  def module_node_title(module_node, klass = '12')
    title =
      if (short_title = module_node.content.short_title).present?
        short_title
      else
        subject = module_node.content.curriculum_subject
        t("curriculum.#{subject}_module_label", idx: module_node.position + 1)
      end

    subtitle = module_node.content.subtitle
    subtitle = subtitle.truncate(klass.include?('12') ? 200: 90, separator: /\s/) if subtitle.present?
    full_title(title, subtitle)
  end

  def unit_node_title(unit_node, multiple = nil)
    subject = unit_node.content.curriculum_subject
    idx = unit_index(subject, unit_node.position)
    unit = unit_node.content

    title =
      if (short_title = unit.short_title).present?
        short_title
      else
        t("curriculum.#{subject}_unit_label", idx: idx)
      end

    subtitle = unit_node.content.subtitle
    if subtitle.present?
      subtitle = subtitle.truncate(multiple.nil? ? 30: 60, separator: /\s/)
      subtitle_class = "r-subtitle-break" if multiple.nil? && subtitle.split(/\s+/).first.length >= 12 && subtitle.length > 20
      #subtitle_class = "r-subtitle-break" if subtitle.split(/\s+/).group_by(&:size).max[0] >= 12 && subtitle.length > 20
    end
    full_title(title, subtitle, subtitle_class)
  end

  def file_icon(type)
    %w(excel doc pdf powerpoint zip).include?(type) ? type : 'unknown'
  end

  def resource_icon(resource)
    resource_types = resource.resource_types.pluck(:name)
    resource_types.include?('video') ? 'video' : 'resource'
  end

  def sidebar_nav_link(curriculum, link_obj)
    link_obj.present? ? unbounded_resource_path(link_obj, curriculum) : '#'
  end

  def resource_presenter(resource)
    yield ResourcePresenter.new(resource)
  end

  def unbounded_resource_path(resource, curriculum = nil)
    slug = curriculum ? resource.slug_for_collection(curriculum.collection) : resource.slug

    if slug
      show_with_slug_path(slug)
    else
      show_path(resource.id)
    end
  end

  def all_units_empty?(_module)
    _module.resource_children.all? { |lc| lc.child.resource_children.empty? }
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

  def full_title(title, subtitle, subtitle_class = nil)
    if subtitle.present?
      content_tag(:span, title, :class => "r-title with-colon") + content_tag(:span, subtitle, :class => "r-subtitle #{subtitle_class}")
    else
      content_tag(:span, title, :class => "r-title")
    end
  end

  def short_unit_title(curriculum, unit, idx)
    if (short_title = unit.short_title).present?
      short_title.tr('nit', '').tr('art', '')
    else
      t("curriculum.#{curriculum.subject}_unit_label", idx: idx + 1)
    end
  end
end