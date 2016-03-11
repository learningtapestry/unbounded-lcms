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
  end

  def children
    if @depth > 0
      kids = if object.item_is_curriculum?
        object.curriculum_item.children
      else
        object.children
      end

      kids.map { |c| CurriculumSerializer.new(c, depth: @depth - 1).as_json }
    else
      []
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
