class CurriculumMap
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def props
    return {} unless resource.present?

    { active: active_branch, results: curriculum }
  end

  private

  def full_depth?
    @full_depth ||= resource.type_is?(:lesson) || resource.type_is?(:unit) || resource.type_is?(:module)
  end

  def active_branch
    @active_branch ||= resource.parents.push(resource).map(&:id).reverse
  end

  def target_branch
    if full_depth?
      mod = resource.parents.detect(&:module?)
      mod ? mod.children.ids : []
    else
      []
    end
  end

  def curriculum
    CurriculumResourceSerializer.new(
      resource.parents.detect(&:grade?),
      depth: full_depth? ? CurriculumTree::HIERARCHY.size : 1,
      depth_branch: active_branch + target_branch
    ).as_json
  end
end
