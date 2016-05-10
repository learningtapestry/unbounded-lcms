module ResourceHelper
  def show_resource_path(resource, curriculum = nil)
    curriculum ||= resource.first_tree

    if curriculum && curriculum.slug
      show_with_slug_path(curriculum.slug.value)
    else
      resource_path(resource)
    end
  end

  def type_name(curriculum)
    curriculum.curriculum_type.name.capitalize
  end

  def back_to_curriculum_path(curriculum)
    slug = curriculum.lesson? ? curriculum.parent.slug.value : curriculum.slug.value
    CGI.unescape(explore_curriculum_index_path(p: slug, e: 1))
  end

  def tag_cloud(curr)
    ntags = curr.named_tags
    ntags[:ell_appropriate] = ntags[:ell_appropriate] ? 'ELL Appropriate' : nil
    ntags.values.flatten.compact.uniq
  end

end
