class Curriculum < ActiveRecord::Base
  acts_as_tree order: 'position', dependent: :destroy

  belongs_to :parent, class_name: 'Curriculum', foreign_key: 'parent_id'

  belongs_to :curriculum_type

  belongs_to :item, polymorphic: true, autosave: true
  belongs_to :resource_item, class_name: 'Resource',
    foreign_key: 'item_id', foreign_type: 'Resource'
  belongs_to :curriculum_item, class_name: 'Curriculum',
    foreign_key: 'item_id', foreign_type: 'Curriculum'

  def self.where_subject(subjects)
    joins(resource_item: [:subjects])
    .where(
      'item_type'   => 'Resource',
      'subjects.id' => Array.wrap(subjects).map(&:id)
    )
  end

  def self.ela
    where_subject(Subject.ela)
  end

  def self.math
    where_subject(Subject.math)
  end

  def self.maps
    where(curriculum_type: CurriculumType.map)
  end

  def self.grades
    where(curriculum_type: CurriculumType.grade)
  end
  
  def self.modules
    where(curriculum_type: CurriculumType.module)
  end
  
  def self.units
    where(curriculum_type: CurriculumType.unit)
  end
  
  def self.lessons
    where(curriculum_type: CurriculumType.lesson)
  end

  def item_is_resource?
    item_type == 'Resource'
  end

  def item_is_curriculum?
    item_type == 'Curriculum'
  end

  def resource
    if item_is_resource?
      item
    elsif item_is_curriculum?
      item.item
    end
  end

  def update_position(new_position)
    transaction do
      ordered = parent.children.to_a
      ordered.insert(new_position, ordered.delete_at(position))
      ordered.each_with_index { |c,i| c.update_attributes(position: i) }
    end
  end

  # Navigation

  def current_level
    if lesson?
      :lesson
    elsif unit?
      :unit
    elsif module?
      :module
    elsif grade?
      :grade
    elsif map?
      :map
    end
  end

  def hierarchy
    [:lesson, :unit, :module, :grade, :map]
  end

  def next
    siblings_after.first
  end

  def previous
    siblings_before.last
  end

  def up(i = 1)
    raise ArgumentError.new('The #up method is 1-indexed') if i < 0
    return self if i == 0
    ancestors[i-1]
  end

  # Maps

  def map?
    curriculum_type == CurriculumType.map
  end

  # Grades

  def grade?
    curriculum_type == CurriculumType.grade
  end

  # Modules

  def module?
    curriculum_type == CurriculumType.module
  end

  # Units

  def unit?
    curriculum_type == CurriculumType.unit
  end

  # Lessons

  def lesson?
    curriculum_type == CurriculumType.lesson
  end

  # Drawing (for debugging)

  def self._draw_node_recursively(node, depth)
    padding = '  '*depth
    sep = depth == 0 ? '' : '-> '
    desc = "#{node.position}. #{node.resource.title} # id #{node.id} -> #{node.item_type}, id #{node.item_id}"
    puts "#{padding}#{sep}#{desc}"

    node.children.each_with_index do |child, i|
      draw_node_recursively(child, depth+1)
    end
  end

  # Draw a text representation of the tree
  def _draw
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    self.class.draw_node_recursively(self, 0)
    ActiveRecord::Base.logger = old_logger
    nil
  end

end
