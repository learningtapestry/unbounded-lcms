class ResourceCollection < ActiveRecord::Base
  include Sluggable

  class TreeNodeWithPosition < Tree::TreeNode
    def position
      parent.children.index(self)
    end
  end

  belongs_to :resource
  belongs_to :resource_collection_type
  has_many :resource_children, dependent: :destroy, inverse_of: :resource_collection
  alias_attribute :children, :resource_children

  validates :resource, presence: true

  accepts_nested_attributes_for :resource_children, allow_destroy: true

  def self.curriculum_maps
    where(resource_collection_type: ResourceCollectionType.curriculum_map)
  end

  def self.curriculum_maps_for(subject)
    Resource.find_curriculum_resources(subject).map(&:curriculum_map_collection)
  end

  def curriculum_map?
    resource_collection_type.curriculum_map? rescue false
  end

  def tree(root_resource = resource)
    @tree ||= build_tree(root_resource, find_relations)
  end

  def as_hash(root_resource = resource)
    build_hash(root_resource, find_relations)
  end

  def add_child(child, parent: resource)
    resource_children.build(
      parent: parent,
      child: child,
      position: next_position(parent)
    )
  end

  def last_position(parent)
    resource_children
      .where(parent: parent)
      .order(position: :desc)
      .first
      .try(:position)
  end

  def next_position(parent)
    (last_position(parent) || 0) + 1
  end

  def find_node(id)
    tree.find { |n| n.content.id == id }
  end

  def delete_branch(parent_id)
    leaves = []
    find_node(parent_id).each do |leaf|
      leaves << [leaf.parent.content.id, leaf.content.id]
    end
    transaction do
      leaves.reverse.each do |(pid, cid)|
        ResourceChild.where(
          parent_id: pid,
          child_id: cid,
          resource_collection_id: self.id
        ).first.destroy
      end
    end
  end

  def copy_branch(branch, parent_id:, position:)
    leaves = []
    branch.each_with_index do |leaf, i|
      if i == 0
        leaves << [parent_id, leaf.content.id, position]
      else
        leaves << [leaf.parent.content.id, leaf.content.id, leaf.position+1]
      end
    end
    transaction do
      ResourceChild.where(parent_id: parent_id, resource_collection_id: self.id).each do |child|
        if child.position >= position
          child.position += 1
          child.save!
        end
      end

      leaves.each do |(pid, cid, pos)|
        ResourceChild.create!(
          parent_id: pid,
          child_id: cid,
          position: pos,
          resource_collection_id: self.id
        )
      end
    end
  end
  
  protected

  def find_relations
    node_relations = {}

    ResourceChild
    .includes(:parent, :child)
    .where(collection: self)
    .each do |child|
      node_relations[child.parent_id] ||= []
      node_relations[child.parent_id] << child
      node_relations[child.parent_id].sort_by! { |c| c.position }
    end

    node_relations
  end

  def build_tree(resource, node_relations)
    tree = build_tree_node(resource)

    if node_relations.has_key?(resource.id)
      node_relations[resource.id].each do |node_rel|
        tree << build_tree(node_rel.child, node_relations)
      end
    end

    tree
  end

  def build_hash(resource, node_relations, position = 0)
    hash = { id: resource.id, title: resource.title, children: [], position: position }

    if node_relations.has_key?(resource.id)
      node_relations[resource.id].each_with_index do |node_rel, index|
        hash[:children] << build_hash(node_rel.child, node_relations, index)
      end
    end

    hash
  end

  def build_tree_node(resource)
    TreeNodeWithPosition.new("#{id}.#{resource.id}", resource)
  end
end
