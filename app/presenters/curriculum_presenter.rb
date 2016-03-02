class CurriculumPresenter < SimpleDelegator
  def active?(node)
    @active ||= (ancestor_ids << id)
    @active.include?(node.id)
  end

  def module_width(node)
    # Find the module with the highest total lesson count.
    @max_module_lesson_count ||= begin
      root
      .children
      .map { |mod| mod.children.map { |unit| unit.children.size }.sum }
      .max
      .to_f
    end

    node_lesson_count = node.children.map{ |unit| unit.children.size }.sum
    node_lesson_count = 1 if node_lesson_count == 0

    ((node_lesson_count / @max_module_lesson_count) * 100).round(2)
  end
end
