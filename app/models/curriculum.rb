#
# `Curriculum` models the hierarchies between educational documents:
#
#   - A document might be a map, a grade, a module, an unit or a lesson.
#   - A map has many grades, a grade has many modules, and so on.
#   - A particular module or unit might appear in MULTIPLE grades or modules.
#
# A `Curriculum` row can have a parent column, which is another `Curriculum`.
# This is how it represents a parent-child relationship.
#
# A `Curriculum` row can also reference a `Resource`, or another `Curriculum`.
# When it references another `Curriculum`, it is referencing another hierarchy.
# Example:
#
# Grade Curriculum          Module Cur. 1            Unit Cur. 1
# |                         |                        |
# | Module Cur. 1 (Cur ref) | Unit Cur. 1 (Cur ref)  | Lesson 1 (Resource ref)
# | Module Cur. 2 (Cur ref) | Unit Cur. 2 (Cur ref)  | Lesson 2 (Resource ref)
#
# In other words, a `Curriculum` tree can reference `Resources` directly, but
# it may also reference another tree.
#
# The root of a `Curriculum` tree will always reference a `Resource`.
# The children of the root will probably reference other trees.
#
# `Curriculum#resource` will find the `Curriculum` `Resource` even if it is
# an indirect reference through a tree.
#
# We're using the library `closure_tree`, which gives us handy methods to deal
# with trees.
# See: https://github.com/mceachen/closure_tree
#
class Curriculum < ActiveRecord::Base
  acts_as_tree order: 'position', dependent: :destroy

  belongs_to :parent, class_name: 'Curriculum', foreign_key: 'parent_id'

  belongs_to :curriculum_type

  belongs_to :item, polymorphic: true, autosave: true
  belongs_to :resource_item, class_name: 'Resource',
    foreign_key: 'item_id', foreign_type: 'Resource'
  belongs_to :curriculum_item, class_name: 'Curriculum',
    foreign_key: 'item_id', foreign_type: 'Curriculum'

  has_many :referrers, class_name: 'Curriculum', as: 'item'

  # Scopes

  scope :with_resources, -> {
    joins(:resource_item).where(item_type: 'Resource')
  }

  scope :with_curriculums, -> {
    joins(:curriculum_item).where(item_type: 'Curriculum')
  }

  scope :where_subject, ->(subjects) {
    subjects = Array.wrap(subjects)
    return where(nil) unless subjects.any?

    with_resources
    .joins(resource_item: [:subjects])
    .where(subjects: { id: Array.wrap(subjects).map(&:id) })
  }

  scope :where_grade, ->(grades) {
    grades = Array.wrap(grades)
    return where(nil) unless grades.any?

    with_resources
    .joins(resource_item: [:grades])
    .where(grades: { id: Array.wrap(grades).map(&:id) })
  }

  scope :ela, -> { where_subject(Subject.ela) }
  scope :math, -> { where_subject(Subject.math) }

  scope :maps, -> { where(curriculum_type: CurriculumType.map) }
  scope :grades, -> { where(curriculum_type: CurriculumType.grade) }
  scope :modules, -> { where(curriculum_type: CurriculumType.module) }
  scope :units, -> { where(curriculum_type: CurriculumType.unit) }
  scope :lessons, -> { where(curriculum_type: CurriculumType.lesson) }

  def item_is_resource?; item_type == 'Resource'; end
  def item_is_curriculum?; item_type == 'Curriculum'; end

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

  def map?; current_level == :map; end
  def grade?; current_level == :grade; end
  def module?; current_level == :module; end
  def unit?; current_level == :unit; end
  def lesson?; current_level == :lesson; end

  def current_level
    curriculum_type.name.to_sym
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
