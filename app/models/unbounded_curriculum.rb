class UnboundedCurriculum
  attr_reader :collection, :current_resource, :current_node, :tree

  def initialize(collection, current_resource = nil)
    @collection = collection
    @tree = collection.tree
    @current_resource = current_resource || first_lesson(tree)
    @current_node ||= tree.find { |n| n.content.id == current_resource.id }
  end

  def current_grade
    @current_grade ||= begin
      if lesson?
        parents[2].content
      elsif unit?
        parents[1].content
      elsif module?
        parents[0].content
      elsif grade?
        current_resource
      end
    end
  end

  def current_lesson
    @current_lesson ||= begin
      if lesson?
        current_resource
      end
    end
  end

  def current_module
    current_module_node.try(:content)
  end

  def current_unit
    @current_unit ||= begin
      if lesson?
        current_node.parent.content
      elsif unit?
        current_resource
      end
    end
  end

  def first_lesson(tree_obj)
    current = tree_obj
    while !current.children.nil?
      current = current.children.first
    end
    current.content
  end

  def first_module_lesson
    current_node.parent.children.first.try(:content)
  end

  def grade?
    current_node.is_root?
  end

  def lesson?
    parents.size == 3 rescue false
  end

  def lessons
    @lessons ||= begin
      if lesson?
        parents[0].children.map(&:content)
      elsif unit?
        current_node.children.map(&:content)
      end
    end
  end

  def module?
    parents.size == 1 rescue false
  end

  def modules
    if grade?
      tree.children.map(&:content)
    end
  end

  def next_lesson
    if lesson?
      current_node.next_sibling.try(:content)
    end
  end

  def next_module
    current_module_node.next_sibling.try(:content)
  end

  def next_module_lesson
    next_module = current_node.parent.next_sibling
    if next_module
      next_module.children.first.try(:content)
    end
  end

  def next_unit
    current_unit_node.next_sibling.try(:content)
  end

  def previous_lesson
    if lesson?
      current_node.previous_sibling.try(:content)
    end
  end

  def previous_module
    current_module_node.previous_sibling.try(:content)
  end

  def previous_unit
    current_unit_node.previous_sibling.try(:content)
  end

  def unit?
    parents.size == 2 rescue false
  end

  def units
    if lesson?
      parents[1].children.map(&:content)
    elsif unit?
      parents[0].children.map(&:content)
    elsif module?
      current_node.children.map(&:content)
    end
  end

  def current_module_node
    @current_module_node ||= begin
      if lesson?
        parents[1]
      elsif unit?
        parents[0]
      elsif module?
        current_node
      end
    end
  end

  def subject
    @subject ||= (parents.last || current_node).content.curriculum_subject
  end

  def resource_kind
    if lesson?
      :lesson
    elsif unit?
      :unit
    elsif module?
      :module
    else
      :grade
    end
  end

  private
    def current_unit_node
      @current_unit_node ||= begin
        if lesson?
          parents[0]
        elsif unit?
          current_node
        end
      end
    end

    def parents
      @parents ||= (current_node.parentage || [])
    end
end
