class UnboundedCurriculum
  attr_reader :collection, :tree

  def initialize(collection, current_lobject = nil)
    @collection = collection, @current_lobject = current_lobject
    @tree = collection.tree
  end

  def current_lobject
    @current_lobject ||= first_lesson(tree)
  end

  def current_node
    @current_node ||= tree.find { |n| n.content.id == current_lobject.id }
  end

  def current_module
    current_node.parent
  end

  def previous_lesson
    current_node.previous_sibling.try(:content)
  end

  def next_lesson
    current_node.next_sibling.try(:content)
  end

  def next_module_lesson
    next_module = current_node.parent.next_sibling
    if next_module
      next_module.children.first.try(:content)
    end
  end

  def first_module_lesson
    current_node.parent.children.first.try(:content)
  end

  def modules
    tree.children
  end

  def units(modul)
    modul.children
  end

  def lessons(unit)
    unit.children.map(&:content)
  end

  def first_lesson(tree_obj)
    current = tree_obj
    while !current.children.nil?
      current = current.children.first
    end
    current.content
  end
end
