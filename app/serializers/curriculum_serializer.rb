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
      object.curriculum_item.children
    else
      object.children
    end

    kids.map { |c| CurriculumSerializer.new(c, depth: @depth - 1).as_json }
  end

  def lesson_count
    cache('lesson_count', 12.hours) { object.lessons.count }
  end

  def unit_count
    cache('unit_count', 12.hours) { object.units.count }
  end

  def module_count
    cache('module_count', 12.hours) { object.modules.count }
  end

  def module_sizes
    cache('module_sizes', 12.hours) do
      object.modules.map do |mod|
        mod.lessons.count
      end
    end
  end

  def unit_sizes
    cache('unit_sizes', 12.hours) do
      object.units.map do |unit|
        unit.lessons.count
      end
    end
  end

  def resource
    CurriculumResourceSerializer.new(object).as_json
  end

  def type
    object.curriculum_type.name
  end

  private
    def cache(key, duration = 1.hours)
      key = "curriculum_serializer/#{object.id}/#{key}"
      Rails.cache.fetch(key, expires_in: duration) { yield }
    end
end
