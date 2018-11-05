# frozen_string_literal: true

CurriculumPresenter.class_eval do
  def level(node)
    Resource::HIERARCHY.index(node.curriculum_type.to_sym)
  end

  def parse_jstree_node(node)
    {
      id: node.id,
      text: node.short_title,
      state: { opened: level(node) < UNIT_LEVEL },
      children: node.children.map { |res| parse_jstree_node(res) },
      li_attr: { title: node.title }
    }
  end
end