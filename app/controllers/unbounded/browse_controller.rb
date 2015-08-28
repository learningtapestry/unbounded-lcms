require 'content/models'

class Unbounded::BrowseController < UnboundedController
  def index
    search = Searches::Unbounded::IndexFacets.new(params)
    @facets = search.facets
  end

  def search
    params[:page] = params[:page].try(:to_i) || 1
    search = Searches::Unbounded::Search.new(params)
    @facets = search.facets
    @results = search.results
    @total_hits = search.total_hits
    @total_pages = (@total_hits + 99)/100
  end

  def show
    @lobject = Presenters::Unbounded::Lobject.new(Content::Models::Lobject.find(params[:id]))
  end
end
