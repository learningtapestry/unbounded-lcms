class CurriculumMapTree
  attr_accessor :id, :active, :item, :children, :parent, :lessons_size

  def active?
    active
  end

  def max_lessons_size
    children.max { |a, b| a.lessons_size <=> b.lessons_size }.lessons_size
  end

  class << self
    def tree(object, active_items, parent = nil)
      new.tap do |t|
        t.id = object.id
        t.active = active?(object, active_items)
        t.item = object
        t.parent = parent
        if object.kids.blank?
          t.children = nil
        else
          t.children = object.kids.includes(:children).includes(:item)
                             .map { |c| tree(c, active_items, object) }
        end
        t.lessons_size = t.children.nil? ? 1 : items_size(t)
      end
    end

    def active?(item, active_items)
      active_items.include? item.resource.id
    end

    def items_size(t)
      t.children.map(&:lessons_size).reduce(0, :+)
    end

  end
end

class CurriculumMapPresenter < SimpleDelegator
  attr_accessor :active_items

  def root_grade
    return @root_grade if @root_grade.present?
    @active_items = []
    @root_grade = Curriculum.grades.where_grade(grade)
                            .where_subject(subject).find { |g| include_item?(g) }
  end

  def map_tree
    @map_tree ||= CurriculumMapTree.tree(root_grade, active_items)
  end

  def module_width(item)
    @max_module_width ||= map_tree.max_lessons_size.to_f
    (item.lessons_size / @max_module_width) * 100
  end

  private

  def include_item?(p)
    if p.resource.id == id
      @active_items << p.resource.id
      return true
    end
    return false if p.kids.blank?
    result = p.kids.includes(:children).includes(:item).any? { |c| include_item?(c) }
    @active_items << p.resource.id if result && !p.unit?
    result
  end

end
