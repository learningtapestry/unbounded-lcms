class CurriculumResourceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :resource, :children, :type, :lesson_count, :unit_count,
             :module_count, :module_sizes, :unit_sizes

  def initialize(object, options = {})
    super(object, options)
    @depth = options[:depth] || 0
    @depth_branch = options[:depth_branch]
  end

  def resource
    ResourceSerializer.new(object).as_json
  end

  def type
    object.curriculum_type
  end

  def children
    return [] if @depth.zero?
    return [] if @depth_branch && !@depth_branch.include?(object.id)

    level_idx = CurriculumTree::HIERARCHY.index(object.curriculum_type.try(:to_sym))
    children_type = CurriculumTree::HIERARCHY[level_idx + 1].to_s.pluralize

    child_resources(object, children_type).ordered.map do |res|
      CurriculumResourceSerializer.new(
        res,
        depth: @depth - 1,
        depth_branch: @depth_branch
      ).as_json
    end
  end

  def lesson_count
    child_resources(object, :lessons).count
  end

  def unit_count
    child_resources(object, :units).count
  end

  def module_count
    child_resources(object, :modules).count
  end

  def module_sizes
    child_resources(object, :modules).ordered.map do |mod|
      child_resources(mod, :lessons).count
    end
  end

  def unit_sizes
    child_resources(object, :units).ordered.map do |unit|
      child_resources(unit, :lessons).count
    end
  end

  def child_resources(parent, type)
    return Resource.none if type.blank?
    Resource.tree.send(type).where_curriculum(parent.curriculum)
  end
end
