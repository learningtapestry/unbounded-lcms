require 'content/models'

module Unbounded
  class BrowseController < UnboundedController
    layout "unbounded_new", only: [:home, :search_new, :show_new]

    def index
      @search = LobjectFacets.new(params)
    end

    def search
      @search = LobjectSearch.new(params)
    end

    def show
      @lobject = LobjectPresenter.new(Content::Models::Lobject.find(params[:id]))
    end

    def home
    end

    def search_new
      @lobjects = []
      (Content::Models::LobjectTitle.find_by(title: 'Math Curriculum Map').lobject.lobject_collections.first.lobject_children.includes(:child).order(position: :asc) rescue []).each do |child|
        @lobjects << LobjectPresenter.new(child.child)
      end
     (Content::Models::LobjectTitle.find_by(title: 'ELA Curriculum Map').lobject.lobject_collections.first.lobject_children.includes(:child).order(position: :asc) rescue []).each do |child|
        @lobjects << LobjectPresenter.new(child.child)
      end
    end

    def show_new
      @lobject = LobjectPresenter.new(Content::Models::Lobject.find(params[:id]))
      @unit = @lobject.collection_trees.map do |tree|
        node = tree.find { |n| n.content.id == @lobject.id }
        node.parent if node.present?
      end
    end

  end
end
