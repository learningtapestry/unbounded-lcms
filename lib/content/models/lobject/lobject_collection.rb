require 'tree'
require 'set'

module Content
  module Models
    class LobjectCollection < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :lobject_collection_type
      has_many :lobject_children, dependent: :destroy
      alias_attribute :children, :lobject_children

      validates :lobject, presence: true

      accepts_nested_attributes_for :lobject_children, allow_destroy: true

      def self.curriculum_maps
        where(lobject_collection_type: LobjectCollectionType.curriculum_map)
      end

      def self.curriculum_maps_for(subject)
        Lobject.find_curriculum_lobjects(subject).map(&:curriculum_map_collection)
      end

      def tree(root_lobject = lobject)
        build_tree(root_lobject, find_relations)
      end

      def as_hash(root_lobject = lobject)
        build_hash(root_lobject, find_relations)
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
        Tree::TreeNode.new("#{id}.#{lobject.id}", lobject)
      end
    end
  end
end
