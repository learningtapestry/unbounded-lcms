require 'content/models'

class Unbounded::BrowseController < UnboundedController
  def index
    @search = Searches::Unbounded::IndexFacets.new(params)
  end

  def search
    @search = Searches::Unbounded::Search.new(params)
  end

  def show
    @lobject = Presenters::Unbounded::Lobject.new(Content::Models::Lobject.find(params[:id]))
  end
end
