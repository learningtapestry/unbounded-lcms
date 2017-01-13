module ResourceHelper
  def show_resource_path(resource, curriculum = nil)
    curriculum ||= resource.first_tree

    if curriculum && curriculum.slug
      show_with_slug_path(curriculum.slug.value)
    else
      resource_path(resource)
    end
  end

  def show_resource_path_curriculum(curriculum)
    show_resource_path(curriculum.resource, curriculum)
  end

  def type_name(curriculum)
    curriculum.curriculum_type.name.capitalize
  end

  def titleize_roman_numerals(s)
    return unless s.present?
    s.titleize.gsub(/\bM{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})\b/i, &:upcase)
  end

  def back_to_curriculum_path(curriculum)
    slug = curriculum.lesson? ? curriculum.parent.slug.value : curriculum.slug.value
    CGI.unescape(explore_curriculum_index_path(p: slug, e: 1))
  end

  def copyrights_text(object)
    cc_descriptions = []
    object.copyrights.each do |copyright|
      cc_descriptions << copyright.value.strip if copyright.value.present?
    end
    object.copyrights.pluck(:disclaimer).uniq.each do |disclaimer|
      cc_descriptions << disclaimer.strip if disclaimer.present?
    end
    cc_descriptions.join(' ')
  end
end
