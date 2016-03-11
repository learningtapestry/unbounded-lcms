module ResourceHelper
  def show_resource_path(resource, curriculum = nil)
    curriculum ||= resource.first_tree

    if curriculum && curriculum.slug
      show_with_slug_path(curriculum.slug.value)
    else
      resource_path(resource)
    end
  end
end
