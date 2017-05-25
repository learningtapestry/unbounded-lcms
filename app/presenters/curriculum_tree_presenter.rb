# Simple presenter for CurriculumTree
class CurriculumTreePresenter < SimpleDelegator
  LEVEL = {
    map:    0,
    grade:  1,
    module: 2,
    unit:   3,
    lesson: 4
  }.freeze

  # Parse tree to be compatible with jstree input data
  def jstree_data
    tree.map { |el| parse_jstree_node(el, 0) }
  end

  def editor_props
    {
      tree: jstree_data,
      form_url: routes.admin_curriculum_tree_path(self)
    }
  end

  private

  def parse_jstree_node(node, level = 0)
    children = node['children'].map { |el| parse_jstree_node(el, level + 1) }
    opened = level < LEVEL[:unit]
    {
      text: node['name'],
      state: { opened: opened },
      children: children
    }
  end

  def routes
    Rails.application.routes.url_helpers
  end
end
