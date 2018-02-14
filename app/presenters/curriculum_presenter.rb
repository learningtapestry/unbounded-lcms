# frozen_string_literal: true

# Simple presenter for Curriculum (resources tree)
class CurriculumPresenter
  UNIT_LEVEL = Resource::HIERARCHY.index(:unit)

  def editor_props
    @editor_props ||= {
      tree: jstree_data,
      form_url: routes.admin_curriculum_path
    }
  end

  private

  # Parse tree to be compatible with jstree input data
  def jstree_data
    Resource.tree.ordered.roots.map { |res| parse_jstree_node(res) }
  end

  def level(node)
    Resource::HIERARCHY.index(node.curriculum_type.to_sym)
  end

  def parse_jstree_node(node)
    {
      id: node.id,
      text: node.short_title,
      state: { opened: level(node) < UNIT_LEVEL },
      children: node.children.tree.ordered.map { |res| parse_jstree_node(res) },
      li_attr: { title: node.title }
    }
  end

  def routes
    Rails.application.routes.url_helpers
  end
end
