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

  def back_to_curriculum_path(curriculum)
    slug = curriculum.lesson? ? curriculum.parent.slug.value : curriculum.slug.value
    CGI.unescape(explore_curriculum_index_path(p: slug, e: 1))
  end

  def tag_cloud(curr)
    tag_clouds(curr).values.flatten.compact.uniq
  end

  def tag_clouds tags_owner
    tags = tags_owner.named_tags
    tags[:ell_appropriate] = tags[:ell_appropriate] ? 'ELL Appropriate' : nil
    tags.transform_values { |v| Array.wrap(v).flatten.compact.uniq.sort }
  end

  def render_tags_cloud cloud_id, cloud_name
    if (tags = @tag_clouds.delete cloud_id).present?
      render partial: 'resources/tags', locals: {
        tags: tags, cloud_name: cloud_name, color_code: @resource.color_code }
    end
  end
end
