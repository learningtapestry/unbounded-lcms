class CurriculumSerializer < ActiveModel::Serializer  
  self.root = false

  attributes :id,
    :resource,
    :children,
    :type,
    :lesson_count,
    :unit_count,
    :module_count,
    :module_sizes,
    :unit_sizes

  def initialize(object, options = {})
    super(object, options)
    @depth = options[:depth] || 0
    @depth_branch = options[:depth_branch]
  end

  def children
    return [] if @depth == 0
    return [] if @depth_branch && !(@depth_branch.include?(object.id))

    kids = if object.item_is_curriculum?
      object.curriculum_item.children.order(position: :asc)
    else
      object.children.order(position: :asc)
    end

    kids.map do |c| 
      CurriculumSerializer.new(c,
        depth: @depth - 1,
        depth_branch: @depth_branch
      ).as_json
    end
  end

  def lesson_count
    object.lessons.count
  end

  def unit_count
    object.units.count
  end

  def module_count
    object.modules.count
  end

  def module_sizes
    object.modules.map do |mod|
      mod.lessons.count
    end
  end

  def unit_sizes
    object.units.map do |unit|
      unit.lessons.count
    end
  end

  def resource
    CurriculumResourceSerializer.new(object).as_json
  end

  def type
    object.curriculum_type.name
  end
end
