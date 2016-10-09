class SearchController < ApplicationController
  include AnalyticsTracking
  include Filterbar
  include Pagination

  before_action :find_documents
  before_action :set_props

  def index
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
    ga_report_pageview(request: request)
  end

  protected


    def find_documents
      @documents = Search::Document.search(search_term, search_params).paginate(pagination_params)
    end

    def set_props
      @props = serialize_with_pagination(@documents,
        pagination: pagination_params,
        each_serializer: SearchDocumentSerializer
      )
      @props.merge!(filterbar_props)
    end
end

