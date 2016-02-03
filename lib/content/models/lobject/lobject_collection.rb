require 'content/models/concerns/sluggable'
require 'set'
require 'tree'

module Content
  module Models
    class LobjectCollection < ActiveRecord::Base
      include Sluggable

      class TreeNodeWithPosition < Tree::TreeNode
        def position
          parent.children.index(self)
        end
      end

      belongs_to :lobject
      belongs_to :lobject_collection_type
      has_many :lobject_children, dependent: :destroy, inverse_of: :lobject_collection
      alias_attribute :children, :lobject_children

      validates :lobject, presence: true

      accepts_nested_attributes_for :lobject_children, allow_destroy: true

      def self.curriculum_maps
        where(lobject_collection_type: LobjectCollectionType.curriculum_map)
      end

      def self.curriculum_maps_for(subject)
        Lobject.find_curriculum_lobjects(subject).map(&:curriculum_map_collection)
      end

      def curriculum_map?
        lobject_collection_type.curriculum_map? rescue false
      end

      def tree(root_lobject = lobject)
        @tree ||= build_tree(root_lobject, find_relations)
      end

      def as_hash(root_lobject = lobject)
        build_hash(root_lobject, find_relations)
      end

      def add_child(child, parent: lobject)
        lobject_children.build(
          parent: parent,
          child: child,
          position: next_position(parent)
        )
      end

      def last_position(parent)
        lobject_children
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
            LobjectChild.where(
              parent_id: pid,
              child_id: cid,
              lobject_collection_id: self.id
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
          LobjectChild.where(parent_id: parent_id, lobject_collection_id: self.id).each do |child|
            if child.position >= position
              child.position += 1
              child.save!
            end
          end

          leaves.each do |(pid, cid, pos)|
            LobjectChild.create!(
              parent_id: pid,
              child_id: cid,
              position: pos,
              lobject_collection_id: self.id
            )
          end
        end
      end
      
      protected

      def find_relations
        node_relations = {}

        LobjectChild
        .includes(parent: [:lobject_titles], child: [:lobject_titles])
        .where(collection: self)
        .each do |child|
          node_relations[child.parent_id] ||= []
          node_relations[child.parent_id] << child
          node_relations[child.parent_id].sort_by! { |c| c.position }
        end

        node_relations
      end

      def build_tree(lobject, node_relations)
        tree = build_tree_node(lobject)

        if node_relations.has_key?(lobject.id)
          node_relations[lobject.id].each do |node_rel|
            tree << build_tree(node_rel.child, node_relations)
          end
        end

        tree
      end

      def build_hash(lobject, node_relations, position = 0)
        hash = { id: lobject.id, title: lobject.title, children: [], position: position }

        if node_relations.has_key?(lobject.id)
          node_relations[lobject.id].each_with_index do |node_rel, index|
            hash[:children] << build_hash(node_rel.child, node_relations, index)
          end
        end

        hash
      end

      def build_tree_node(lobject)
        TreeNodeWithPosition.new("#{id}.#{lobject.id}", lobject)
      end
    end
  end
end
