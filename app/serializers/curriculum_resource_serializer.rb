class CurriculumResourceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :children, :id, :lesson_count, :module_count, :module_sizes,
             :resource,  :type, :unit_count, :unit_sizes

  def initialize(object, options = {})
    super(object, options)
    @depth = options[:depth] || 0
    @depth_branch = options[:depth_branch]
  end

  def resource
    ResourceDetailsSerializer.new(object).as_json
  end

  def type
    object.curriculum_type
  end

  def children
    return [] if @depth.zero?
    return [] if @depth_branch && !@depth_branch.include?(object.id)

    object.children.ordered.map do |res|
      CurriculumResourceSerializer.new(
        res,
        depth: @depth - 1,
        depth_branch: @depth_branch
      ).as_json
    end
  end

  def lesson_count
    count = descendants.select(&:lesson?).count
    object.assessment? ? count + 1 : count
  end

  def unit_count
    descendants.select(&:unit?).count
  end

  def module_count
    descendants.select(&:module?).count
  end

  def module_sizes
    descendants.select(&:module?).map { |r| r.self_and_descendants.lessons.count }
  end

  def unit_sizes
    descendants.select(&:unit?).map do |r|
      count = r.self_and_descendants.lessons.count
      r.assessment? ? count + 1 : count
    end
  end

  def descendants
    @descendants ||= object.self_and_descendants.ordered
  end
end
