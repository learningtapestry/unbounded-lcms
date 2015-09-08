require 'tree'
require 'set'

module Content
  module Models
    class LobjectCollection < ActiveRecord::Base
      belongs_to :lobject
      has_many :lobject_children, dependent: :destroy
      alias_attribute :children, :lobject_children

      validates :lobject, presence: true

      accepts_nested_attributes_for :lobject_children, allow_destroy: true

      def tree(root_lobject = lobject)
        node_relations = {}

        LobjectChild
        .includes(parent: [:lobject_titles], child: [:lobject_titles])
        .where(collection: self)
        .each do |child|
          node_relations[child.parent_id] ||= []
          node_relations[child.parent_id] << child
          node_relations[child.parent_id].sort_by! { |c| c.position }
        end

        build_tree(root_lobject, node_relations)
      end
      
      protected

      def build_tree(lobject, node_relations)
        tree = build_tree_node(lobject)

        if node_relations.has_key?(lobject.id)
          node_relations[lobject.id].each do |node_rel|
            tree << build_tree(node_rel.child, node_relations)
          end
        end

        tree
      end

      def build_tree_node(lobject)
        Tree::TreeNode.new("#{id}.#{lobject.id}", lobject)
      end
    end
  end
end
